% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/resample_gifti.R
\name{make_helper_spheres}
\alias{make_helper_spheres}
\title{Generate GIFTI sphere surface files}
\usage{
make_helper_spheres(
  sphereL_fname,
  sphereR_fname,
  resamp_res,
  write_dir = NULL,
  wb_path = NULL
)
}
\arguments{
\item{sphereL_fname}{File path to left-hemisphere spherical GIFTI to be 
created}

\item{sphereR_fname}{File path to right-hemisphere spherical GIFTI to be 
created}

\item{resamp_res}{Target resolution for resampling (number of 
cortical surface vertices per hemisphere).}

\item{write_dir}{(Optional) directory to place the sphere files in. If
\code{NULL} (default), do not append any directory to the sphere file paths.}

\item{wb_path}{(Optional) Path to Connectome Workbench folder or executable. 
If not provided, should be set with 
\code{ciftiTools.setOption("wb_path", "path/to/workbench")}.}
}
\value{
Logical indicating whether output files exist.
}
\description{
This function generates a pair of GIFTI vertex-matched left and 
 right spheres in the target resolution. These are required for resampling 
 CIFTI and GIFTI files.
}
