% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/write_cifti.R
\name{write_gifti_component_of_cifti}
\alias{write_gifti_component_of_cifti}
\title{Write out a GIFTI File}
\usage{
write_gifti_component_of_cifti(data, out_fname, datatype = NULL, ...)
}
\arguments{
\item{data}{A data matrix to write out as a GIFTI, i.e. a V (vertices) by T
(measurements) matrix correpsonding to the left or right cortex.}

\item{out_fname}{The path to the GIFTI file to write}

\item{datatype}{A vector corresponding to the NIFTI types of \code{data}.
For example, "NIFTI_TYPE_INT32" and "NIFTI_TYPE_FLOAT32". If \code{NULL}
(default), the datatype will be inferred.}

\item{...}{Other vectors of options to 
\code{\link[freesurferformats]{gifti_xml}}, for example "encoding" and
"endian".}
}
\description{
Write GIFTI-format data.
}
\keyword{internal}
