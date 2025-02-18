#' Create a list with Google Sheets metadata for tables hosted on the platform
#'
#' @description
#'
#' `r lifecycle::badge("experimental")`
#'
#' __CAUTION__: This function must be used only with packages that follow the
#' `sqlr` system.
#'
#' `write_metadata()` creates and returns a `list` object containing lists with
#' the Google Sheets metadata of the review tables hosted on the platform.
#'
#' You can see a example of a metadata sheets in: <https://bit.ly/2PFWhev>.
#'
#' @param id A string with the Google Sheets ID from the `Sheets` table.
#' @param sheet (optional) a string indicating the worksheet/tab where the
#'   sheets data can be found in the `Sheets` spreadsheet (default:
#'   `"Dataset"`).
#'
#' @return An invisible `list` object containing lists with the Google Sheets
#'   metadata of the review tables hosted on the platform.
#'
#' @family Google Sheets functions
#' @export
#'
#' @examples
#' \dontrun{
#' write_metadata("1x6Aj8cXl9qFtpXq48Q6zdmT-w9EEqNG1iVQcKVRhgKM")
#' }
write_metadata <- function(id, sheet = "Dataset") {
    checkmate::assert_string(id)
    checkmate::assert_string(sheet)
    rutils:::assert_interactive()
    rutils:::require_pkg("googlesheets4")

    name <- where <- NULL # R CMD Check variable bindings fix

    googlesheets4::gs4_deauth()

    data <- googlesheets4::read_sheet(id, sheet, col_types = "c",
                                      na = c("", "NA"))

    data <- data %>%
        dplyr::filter(!(name == "operators")) %>%
        dplyr::mutate(across(where(is.character), stringr::str_squish))

    sheets <- list()

    for (i in seq_len(nrow(data))) {
        sheets[[data$name[i]]] <- list(name = data$name[i],
                                       type = data$type[i],
                                       id = data$id[i],
                                       sheet = data$sheet[i])
    }

    cli::cli_alert_info(paste0(
        "{.strong {cli::col_red('Run (in order)')}}:\n\n",
        "{.strong devtools::document() [Ctrl + Shift  + D]\n",
        "devtools::load_all() [Ctrl + Shift  + L]}"))

    if (!(dir.exists("./data/"))) dir.create("./data/")
    file <- "./data/sheets.rda"
    save("sheets", file = file, envir = environment(), compress = "bzip2",
         version = 2)

    invisible(sheets)
}

#' Read the review tables hosted on Google Sheets
#'
#' @description
#'
#' `r lifecycle::badge("experimental")`
#'
#' __CAUTION__: This function must be used only with packages that follow the
#' `sqlr` system.
#'
#' `read_sheet()` reads and returns the review tables hosted on Google Sheets.
#'
#' You must have a `sheets` data object with the sheets metadata before running
#' this function. See [write_metadata()] to learn more.
#'
#' @param name (optional) A `character` object indicating the name or names of
#'   the sheets that the function must return (default: `NULL`).
#'
#' @return
#'
#' * If `name = NULL`, an invisible `list` object with `tibbles` objects of all
#' entity sheet/tables available as elements, with the exception of the
#' 'sheets', 'reference', and 'document' tables and any other non-entity tables.
#' * If `name` have length > 1, an invisible `list` object with `tibbles`
#' objects of sheet/tables indicated in `name` as elements.
#' * If `name` have length == 1, an invisible `tibble` object of the sheet/table
#' indicated in `name`.
#'
#' @family Google Sheets functions
#' @template param_a
#' @export
#'
#' @examples
#' \dontrun{
#' ## To get a 'list' object with all the sheets
#'
#' read_sheet()
#'
#' ## To get a 'list' object with some sheets
#'
#' read_sheet(c(names(sheets)[2], names(sheets)[3]))
#'
#' ## To get a 'tibble' object of a specific sheet
#'
#' read_sheet(names(sheets)[2])
#' }
read_sheet <- function(name = NULL, package = rutils:::get_package_name()) {
    checkmate::assert_character(name, any.missing = FALSE,
                                all.missing = FALSE, null.ok = TRUE)
    checkmate::assert_string(package, null.ok = TRUE)
    rutils:::assert_interactive()
    rutils:::require_pkg("utils", "googlesheets4")
    rutils:::assert_namespace(package)
    rutils:::assert_data("sheets", package)

    sheets <- NULL # R CMD Check variable bindings fix

    utils::data("sheets", package = package, envir = environment())
    checkmate::assert_subset(name, names(sheets), empty.ok = TRUE)

    if (!is.null(name)) {
        sheets <- sheets[name]
    } else {
        filter <- function(x) {
            (tolower(x$type) == "entity" &&
                !tolower(x$name) %in% c("reference", "document")) %>%
                rutils:::rm_na()
        }

        sheets <- sheets[vapply(sheets, filter, logical(1))]
        name <- names(sheets)
    }

    if (any(vapply(sheets, function(x) is.na(x$id), logical(1)))) {
        cli::cli_abort(paste0(
            "At least one sheet in {.strong {cli::col_red('name')}} ",
            "doesn't have an ID value in the ",
            "{.strong {cli::col_blue('sheets')}}  table. ",
            "You may need to run {.strong write_metadata()} ",
            "before running {.strong read_sheet()}."
        ))
    }

    googlesheets4::gs4_deauth()

    for (i in sheets) {
        data <- googlesheets4::read_sheet(i$id, i$sheet, na = c("", "NA"))
        assign(i$name, data)
    }

    if (length(name) == 1) {
        invisible(get(name))
    } else {
        variables <- mget(ls())
        invisible(variables[name])
    }
}

#' Write the review tables hosted on Google Sheets to the package
#'
#' @description
#'
#' `r lifecycle::badge("experimental")`
#'
#' __CAUTION__: This function must be used only with packages that follow the
#' `sqlr` system.
#'
#' `write_sheet()` reads and write the review tables hosted on Google Sheets in
#' the data directory of an R package.
#'
#' You must have a `sheets` data object with the sheets metadata before running
#' this function. See [write_metadata()] to learn more.
#'
#' `write_sheet()` don't rewrite the `sheets`, `reference` or `document` table.
#' It also don't write non-entity tables.
#'
#' @param name (optional) A `character` object indicating the name or names of
#'   the sheets that the function must write (default: `NULL`).
#'
#' @family Google Sheets functions
#' @template param_a
#' @export
#'
#' @examples
#' \dontrun{
#' ## To write all sheets
#'
#' write_sheet()
#'
#' ## To write one or more specific sheets
#'
#' write_sheet(sheets$domain$name)}
write_sheet <- function(name = NULL, package = rutils:::get_package_name()) {
    checkmate::assert_character(name, any.missing = FALSE,
                                all.missing = FALSE, null.ok = TRUE)
    checkmate::assert_string(package, null.ok = TRUE)
    rutils:::assert_interactive()
    rutils:::require_pkg("utils", "googlesheets4")
    rutils:::assert_namespace(package)
    rutils:::assert_data("sheets", package)

    sheets <- NULL # R CMD Check variable bindings fix

    utils::data("sheets", package = package, envir = environment())

    filter <- function(x) {
        (tolower(x$type) == "entity" &&
            !tolower(x$name) %in% c("reference", "document")) %>%
            rutils:::rm_na()
    }

    sheets <- sheets[vapply(sheets, filter, logical(1))]

    if (!is.null(name)) {
        if (!all(name %in% names(sheets), na.rm = TRUE)) {
            cli::cli_abort(paste0(
                "At least one of the names in ",
                "{.strong {cli::col_red('name')}} ",
                "was not found in the ",
                "{.strong {cli::col_blue('sheets')}}  table ",
                "or it indicates the {.strong reference}, ",
                "{.strong document}, or non-entity tables ",
                "(that cannot be written)."
            ))
        }

        if (length(name) == 1) {
            assign(name, read_sheet(name = name, package = package))
        } else {
            list2env(read_sheet(name, package), envir = environment())
        }
    } else {
        list2env(read_sheet(names(sheets), package), envir = environment())
        name <- names(sheets)
    }

    envir <- environment()

    for (i in name) {
        if (!(dir.exists("./data/"))) dir.create("./data/")
        file <- paste0("./data/", i, ".rda")
        save(list = i, file = file, envir = envir, compress = "bzip2",
             version = 2)
    }

    cli::cli_alert_info(paste0(
        "{.strong {cli::col_red('Run (in order)')}}:\n\n",
        "{.strong devtools::document() [Ctrl + Shift  + D]\n",
        "devtools::load_all() [Ctrl + Shift  + L]}"))

    invisible(NULL)
}

#' Get the number of rows from a review table hosted on Google Sheets
#'
#' @description
#'
#' `r lifecycle::badge("experimental")`
#'
#' __CAUTION__: This function must be used only with packages that follow the
#' `sqlr` system.
#'
#' `sheet_nrow()` returns the number of rows of a review table hosted on Google
#' Sheets.
#'
#' You must have a `sheets` data object with the sheets metadata before running
#' this function. See [write_metadata()] to learn more.
#'
#' @param name A string indicating the name of the sheets that the
#'   function must evaluate.
#' @param rm_header (optional) A `logical` value indicating if the function
#' must consider the header when computing the number of rows. This only works
#' when the sheets have one line as header (default: `TRUE`).
#'
#' @family Google Sheets functions
#' @template param_a
#' @export
#'
#' @examples
#' \dontrun{
#' sheet_nrow(sheets$domain$name)}
sheet_nrow <- function(name,
                       package = rutils:::get_package_name(),
                       rm_header = TRUE) {
    checkmate::assert_string(name)
    checkmate::assert_string(package, null.ok = TRUE)
    checkmate::assert_flag(rm_header)
    rutils:::require_pkg("utils", "googlesheets4")
    rutils:::assert_namespace(package)
    rutils:::assert_data("sheets", package)

    sheets <- NULL # R CMD Check variable bindings fix

    utils::data("sheets", package = package, envir = environment())

    if (!name %in% names(sheets)) {
        cli::cli_abort(paste0(
            "{.strong {cli::col_red(name)}} was not found in the ",
            "{cli::col_blue('sheets')} table."
        ))
    }

    properties <- googlesheets4::sheet_properties(sheets[[name]]$id)
    out <- properties$grid_rows[which(properties$name == sheets[[name]]$sheet)]

    if (isTRUE(rm_header)) out <- out - 1

    out
}

#' Write a `data.frame` object to a review table hosted on Google Sheets
#'
#' @description
#'
#' `r lifecycle::badge("experimental")`
#'
#' __CAUTION__: This function must be used only with packages that follow the
#' `sqlr` system.
#'
#' `range_write()` writes a `data.frame` object to a specific range of a review
#' table hosted on Google Sheets.
#'
#' This function was created as workaround to [googlesheets4::range_write]
#' writing limit. It bypass this limit by writing in batches.
#'
#' Please note that this function will always write in the `A1` range and will
#' delete all but the 2 first rows of the worksheet before writing on it.
#'
#' You must have a `sheets` data object with the sheets metadata before running
#' this function. See [write_metadata()] to learn more.
#'
#' @param x A `data.frame` object with at least 1 row.
#' @param name A string indicating the name of the sheets that the
#'   function must write.
#' @param limit (optional) a number with the limit amount of data to write for
#'   each batch. Example: a limit of `200000` will write a `data.frame` with
#'   `10000` rows and `50` columns in 3 batches, because `10000 * 50 = 500000`
#'   (over the limit) and `ceiling(500000 / 200000) = 3` (default: `200000`).
#'
#' @family Google Sheets functions
#' @template param_a
#' @export
#'
#' @examples
#' \dontrun{
#' range_write(reference, "reference")}
range_write <- function(x, name, package = rutils:::get_package_name(),
                        limit = 200000) {
    checkmate::assert_data_frame(x, min.rows = 1)
    checkmate::assert_string(name)
    checkmate::assert_string(package, null.ok = TRUE)
    checkmate::assert_number(limit, lower = 5000)
    rutils:::require_pkg("utils", "googlesheets4")

    # R CMD Check variable bindings fix
    sheets <- where <- NULL

    rutils:::assert_namespace(package)
    rutils:::assert_data("sheets", package)

    utils::data("sheets", package = package, envir = environment())

    if (!name %in% names(sheets)) {
        cli::cli_abort(paste0(
            "{.strong {cli::col_red(name)}} was not found in the ",
            "{cli::col_blue('sheets')} table."
        ))
    }

    str_subset <- function(x) {
        dplyr::case_when(
            nchar(x) >= 50000 ~ stringr::str_sub(x, 1, 49999),
            TRUE ~ x
        )
    }

    x <- x %>% dplyr::mutate(dplyr::across(where(is.character), str_subset))

    googlesheets4::sheet_resize(ss = sheets[[name]]$id,
                                sheet = sheets[[name]]$sheet,
                                nrow = 2,
                                ncol = NULL,
                                exact = TRUE)

    if (limit >= prod(dim(x))) {
        googlesheets4::range_write(ss = sheets[[name]]$id,
                                   data = x,
                                   sheet = sheets[[name]]$sheet,
                                   range = "A1",
                                   col_names = TRUE,
                                   reformat = FALSE)
    } else {
        batch <- limit / ncol(x)

        googlesheets4::range_write(ss = sheets[[name]]$id,
                                   data = x[seq(batch), ],
                                   sheet = sheets[[name]]$sheet,
                                   range = "A1",
                                   col_names = TRUE,
                                   reformat = FALSE)

        rows <- sheet_nrow(name, package, rm_header = TRUE)

        while (rows < nrow(x)) {
            if (rows + batch > nrow(x)) {
                from <- rows + 1
                to <- nrow(x)
            } else if (rows + batch <= nrow(x)) {
                from <- rows + 1
                to <- from + batch - 1
            }

            googlesheets4::sheet_append(ss = sheets[[name]]$id,
                                        data = x[seq(from, to), ],
                                        sheet = sheets[[name]]$sheet)

            rows <- sheet_nrow(name, package, rm_header = TRUE)
        }

        if (rows != nrow(x)) {
            cli::cli_abort(paste0(
                "{.strong {cli::col_red('Critical error')}}: ",
                "The number of rows written does not match ",
                "the number of lines in {.strong x}. ",
                "Check the function code."
            ))
        }
    }

    invisible(NULL)
}
