% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/resample_cifti.R
\name{resample_cifti}
\alias{resample_cifti}
\alias{resampleCIfTI}
\title{Resample CIFTI Data}
\usage{
resample_cifti(
  cifti_original_fname,
  cifti_target_fname,
  surfL_original_fname = NULL,
  surfR_original_fname = NULL,
  surfL_target_fname = NULL,
  surfR_target_fname = NULL,
  resamp_res,
  sphereL_fname,
  sphereR_fname,
  sep_keep = FALSE,
  sep_fnames = NULL,
  resamp_keep = FALSE,
  resamp_fnames = NULL,
  write_dir = NULL,
  verbose = TRUE,
  wb_path = NULL
)

resampleCIfTI(
  cifti_original_fname,
  cifti_target_fname,
  surfL_original_fname = NULL,
  surfR_original_fname = NULL,
  surfL_target_fname = NULL,
  surfR_target_fname = NULL,
  resamp_res,
  sphereL_fname,
  sphereR_fname,
  sep_keep = FALSE,
  sep_fnames = NULL,
  resamp_keep = FALSE,
  resamp_fnames = NULL,
  write_dir = NULL,
  verbose = TRUE,
  wb_path = NULL
)
}
\arguments{
\item{cifti_original_fname}{A CIFTI file to resample.}

\item{cifti_target_fname}{The file name to save the resampled CIFTI.}

\item{surfL_original_fname, surfR_original_fname}{(Optional) File path of 
existing GIFTI surface geometry file representing the left/right cortex. 
One or both can be provided.}

\item{surfL_target_fname, surfR_target_fname}{(Optional) File path for
the resampled GIFTI surface geometry file representing the left/right 
cortex. If NULL (default), will use default names: see 
\code{resample_cifti_default_fname}.}

\item{resamp_res}{Target resolution for resampling (number of 
cortical surface vertices per hemisphere).}

\item{sphereL_fname}{The left GIFTI sphere file in the same resolution
as the CIFTI data. It is required for resampling.}

\item{sphereR_fname}{The right GIFTI sphere file in the same resolution
as the CIFTI data. It is required for resampling.}

\item{sep_keep}{If separated files are created, should they be kept or 
deleted at the end of this function call? Default: \code{FALSE} (delete).
Keeping the separated files may help speed up certain tasks, for example
when repeatedly iterating over subjects--the CIFTI will only be separated
once instead of at each iteration.}

\item{sep_fnames}{(Optional) Where to write the separated files (override
 their default file names). This is a named list 
 where each entry's name is a file type label, and each entry's value
 is a file name indicating where to write the corresponding separated file. 
 The recognized file type labels are: "cortexL", "cortexR", 
 "ROIcortexL", "ROIcortexR", "subcortVol", and "subcortLab".
 
 Entry values can be \code{NULL}, in which case a default file name will be 
 used: see \code{\link{cifti_component_suffix}}. Default file names
 will also be used for files that need to be separated/written but without a
 corresponding entry in \code{sep_fnames}.
 
 Entries in \code{sep_fnames} will be ignored if they are not needed
 based on \code{[ROI_]brainstructures}. For example, if
 \code{brainstructures="left"}, then \code{sep_fnames$cortexR} will be 
 ignored if specified. 

 The \code{write_dir} argument can be used to place each separated file in
 the same directory.}

\item{resamp_keep}{If resampled files are created, will they be kept or 
deleted at the end of this function call? Default: \code{FALSE} (delete).
Keeping the resampled files may help speed up certain tasks, for example
when repeatedly iterating over CIFTI files--resampling will only be done
once instead of every new iteration.}

\item{resamp_fnames}{Where to write the resampled files. This is a named list 
 where each entry's name is a file type label, and each entry's value
 is a file name indicating where to write the corresponding resampled file. 
 The recognized file type labels are: "cortexL", "cortexR", 
 "ROIcortexL", "ROIcortexR", "validROIcortexL", and "validROIcortexR".
 
 Entry values can be \code{NULL}, in which case a default file name will be 
 used: see \code{\link{resample_cifti_default_fname}}. Default file names
 will also be used for files that need to be resampled/written but without a
 corresponding entry in \code{resamp_fnames}.
 
 Entries in \code{resamp_fnames} will be ignored if they are not needed
 based on \code{[ROI_]brainstructures}. For example, if
 \code{brainstructures="left"}, then \code{resamp_fnames$cortexR} will be 
 ignored if specified. 

 The \code{write_dir} argument can be used to place each resampled file in
 the same directory.}

\item{write_dir}{Where should any output files be written? \code{NULL}
 (default) will write them to the current working directory.

 Files flagged for deletion will be written to a temporary directory, and
 thus are not affected by this argument. So if \code{sep_keep} is 
 \code{TRUE}, the separated files will be written to \code{write_dir}, but if
 \code{sep_keep} is \code{FALSE}, they will be written to \code{tempdir()} 
 and later deleted. \code{resamp_keep} works similarly. 

 For \code{read_cifti_separate}, the surface files (\code{surfL} or \code{surfR})
 are deleted if \code{resamp_keep} is \code{FALSE}, so in this case they will
 be written to \code{tempdir()}. But for \code{resample_cifti}, the
 surface files are kept even if \code{resamp_keep} is \code{FALSE}, so they 
 will always be written to \code{write_dir}. 

 Different subfolders for the separated, resampled, and final output files
 cannot be specified by \code{write_dir}. Instead, modify the individual file
 names in \code{sep_fnames} and \code{resamp_fnames}.

 \code{write_dir} must already exist, or an error will occur.}

\item{verbose}{Should occasional updates be printed? Default: \code{TRUE}.}

\item{wb_path}{(Optional) Path to Connectome Workbench folder or executable. 
If not provided, should be set with 
\code{ciftiTools.setOption("wb_path", "path/to/workbench")}.}
}
\value{
A list of output files written. The elements are "cifti" and
 potentially "surfL" (if \code{surfL_original_fname} was provided) and 
 "surfR" (if \code{surfR_original_fname} was provided).
}
\description{
Performs spatial resampling of CIFTI data on the cortical surface
 by separating it into GIFTI and NIFTI files, optionally resampling them, 
 and then using the \code{-cifti-resample} Workbench Command with a template.
}
\details{
This function uses a system wrapper for the "wb_command"
 executable. The user must first download and install the Connectome 
 Workbench, available from 
 \url{https://www.humanconnectome.org/software/get-connectome-workbench}. 
 The \code{wb_path} argument is the path to the Connectime Workbench folder or
 executable.
}
