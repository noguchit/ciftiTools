% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_cifti_flat.R
\name{read_cifti_flat}
\alias{read_cifti_flat}
\title{Read Only the Data from a CIFTI File}
\usage{
read_cifti_flat(
  cifti_fname,
  keep = FALSE,
  gifti_fname = NULL,
  write_dir = NULL,
  wb_path = NULL
)
}
\arguments{
\item{cifti_fname}{File path of CIFTI-format data (ending in .d*.nii).}

\item{keep}{\code{read_cifti_minimal} works by saving the CIFTI as a GIFTI file, 
and then reading it in. Should the GIFTI file be kept? If \code{FALSE}
(default), write it in a temporary directory regardless of \code{write_dir}.}

\item{gifti_fname}{File path of GIFTI-format data to save the CIFTI as. 
Default: the CIFTI_fname but with the extension replaced with "flat.gii".}

\item{write_dir}{The directory in which to save the GIFTI, if it is being 
kept. If \code{NULL} (default), use the current working directory.}

\item{wb_path}{(Optional) Path to Connectome Workbench folder or executable. 
If not provided, should be set with 
\code{ciftiTools.setOption("wb_path", "path/to/workbench")}.}
}
\value{
A T x B matrix of class "cifti_data", where T is the number of 
 measurements and B is the number of brainordinates in the CIFTI file.
}
\description{
Reads CIFTI data as a matrix by converting it to a GIFTI.
 This uses the \code{-cifti-convert -to-gifti-ext} Connectome 
 Workbench command. The result will be a T x B matrix (T measurements, B 
 non-empty brainordinates). All brainstructures will be obtained, but 
 they will be undifferentiable. Medial wall vertices and voxels outside the
 brain mask will not be included. No spatial information is included. This is 
 the fastest way to read in CIFTI data.
}
\details{
This function uses a system wrapper for the "wb_command"
 executable. The user must first download and install the Connectome
 Workbench, available from
 \url{https://www.humanconnectome.org/software/get-connectome-workbench}.
 The \code{wb_path} argument is the path to the Connectime Workbench folder
 or executable.
}
