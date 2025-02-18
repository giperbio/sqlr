% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils-sheets.R
\name{write_metadata}
\alias{write_metadata}
\title{Create a list with Google Sheets metadata for tables hosted on the platform}
\usage{
write_metadata(id, sheet = "Dataset")
}
\arguments{
\item{id}{A string with the Google Sheets ID from the \code{Sheets} table.}

\item{sheet}{(optional) a string indicating the worksheet/tab where the
sheets data can be found in the \code{Sheets} spreadsheet (default:
\code{"Dataset"}).}
}
\value{
An invisible \code{list} object containing lists with the Google Sheets
metadata of the review tables hosted on the platform.
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}

\strong{CAUTION}: This function must be used only with packages that follow the
\code{sqlr} system.

\code{write_metadata()} creates and returns a \code{list} object containing lists with
the Google Sheets metadata of the review tables hosted on the platform.

You can see a example of a metadata sheets in: \url{https://bit.ly/2PFWhev}.
}
\examples{
\dontrun{
write_metadata("1x6Aj8cXl9qFtpXq48Q6zdmT-w9EEqNG1iVQcKVRhgKM")
}
}
\seealso{
Other Google Sheets functions: 
\code{\link{range_write}()},
\code{\link{read_sheet}()},
\code{\link{sheet_nrow}()},
\code{\link{write_query}()},
\code{\link{write_sheet}()}
}
\concept{Google Sheets functions}
