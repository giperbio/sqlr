% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/selection_stats.R
\name{selection_stats}
\alias{selection_stats}
\title{Print statistics about the selection process}
\usage{
selection_stats(
  package = rutils:::get_package_name(),
  trial_id = NULL,
  clipboard = TRUE
)
}
\arguments{
\item{package}{(optional) a string indicating the package with the database
data. If not assigned, the function will try to use the name of the active
project directory (requires the \code{rstudioapi} package).}

\item{trial_id}{(optional) a string indicating the ID of the trial. This
argument must be set only when the function must print a trial statistics
(default: \code{NULL}).}

\item{clipboard}{(optional) a \code{logical} value indicating if the function must
copy a Markdown version of the statistics to the clipboard. (default:
\code{TRUE}).}
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}

\strong{CAUTION}: This function must be used only with packages that follow the
\code{sqlr} system.

\code{selection_stats()} prints statistics about a trial or the selection process
as a whole.

The trial statistics are computed by downloading the trial table (requires an
internet connection). The full statistics are computed using the \code{reference}
data of a SQLR package, hence, the data of the package must be up-to-date.
}
\examples{
\dontrun{
selection_stats()}
}
\concept{selection functions}
