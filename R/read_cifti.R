#' Read a CIFTI File
#'
#' @description Make a "xifti" from CIFTI data either by exporting it as a single 
#'  GIFTI using the \code{-cifti-convert -to-gifti-ext} Workbench Command, or by 
#'  separating it into multiple GIFTIs (cortical surfaces) and a NIFTI 
#'  (subcortical data) using the \code{-cifti-separate} Workbench Command. The 
#'  former is much faster, so the latter is only used when necessary:
#'  if resampling is to be performed, or if the NIFTI volume must be 
#'  obtained without cropping. See \code{\link{read_cifti_convert}} to directly
#'  use the former, and \code{\link{read_cifti_separate}} to directly
#'  use the latter.
#' 
#'  With either method, metadata is obtained with \code{\link{map_cifti}}.
#'
#' @inheritParams cifti_fname_Param
#' @param flat Should the result be flattened into a single matrix? If \code{TRUE},
#'  the result will be a T x B matrix (T measurements, B brainordinates not including
#'  the medial wall). All below arguments will be ignored, because the brain 
#'  structures cannot be identified and surfaces will not be appended. 
#'  Resampling is also not possible.
#' 
#'  This is the fastest way to read in just the CIFTI data. 
#' 
#'  The brainordinates will be ordered by left cortex, right cortex, and then 
#'  subcortical, but where each brainstructure begins, as well as which 
#'  structures each brainordinate represents, cannot be determined. The
#'  medial wall vertices and subcortical brain mask are also not included. The 
#'  data matrix will be identical to that created by 
#'  \code{-cifti-convert -to-gifti-ext}.
#' 
#'  If \code{FALSE}, the result will be a "xifti" object.
#' @inheritParams surfL_fname_Param
#' @inheritParams surfR_fname_Param
#' @inheritParams brainstructures_Param_LR 
#' @param full_volume Is the full subcortical volume required, or
#'  is it okay to crop it by removing empty edge slices? Default: \code{FALSE}.
#'  If \code{TRUE}, the data will have to be read in with 
#'  \code{-cifti-separate}, which is slower than 
#'  \code{-cifti-convert -to-gifti-ext}.
#' @param resamp_res Resolution to resample the cortical data and surface to.
#'  Default: \code{NULL} (do not resample). If not \code{NULL}, the data will 
#'  have to be read in with \code{-cifti-separate}, which is slower than 
#'  \code{-cifti-convert -to-gifti-ext}.
#' 
#'  Spheres in the original resolution are required (\code{sphereL_fname} and 
#'  \code{sphereR_fname}).
#' @inheritParams sphereL_fname_Param
#' @inheritParams sphereR_fname_Param
#' @inheritParams wb_path_Param
#' @inheritParams verbose_Param_FALSE
#' @param ... Additional arguments to \code{\link{read_cifti_convert}} or 
#'  \code{\link{read_cifti_separate}}.
#'
#' @return If \code{!flat}, a \code{"xifti"} object. Otherwise,, a T x B matrix 
#'  (T measurements, B brainordinates). 
#' 
#'  See \code{\link{is.xifti}} for details about \code{"xifti"} objects.
#' @export
#'
#' @details This function uses a system wrapper for the "wb_command"
#'  executable. The user must first download and install the Connectome
#'  Workbench, available from
#'  \url{https://www.humanconnectome.org/software/get-connectome-workbench}.
#'  The \code{wb_path} argument is the path to the Connectime Workbench folder
#'  or executable.
#'
read_cifti <- function(
  cifti_fname, flat=FALSE,
  surfL_fname=NULL, surfR_fname=NULL,
  brainstructures=c("left","right"), 
  full_volume=FALSE,
  resamp_res=NULL, sphereL_fname=NULL, sphereR_fname=NULL,
  wb_path=NULL, verbose=FALSE, ...){

  # ----------------------------------------------------------------------------
  # Handle flat method. --------------------------------------------------------
  # ----------------------------------------------------------------------------

  if (flat) {
    if (full_volume) {
      warning(paste(
        "No subcortical mask can be computed with the flat method.",
        "Ignoring `full_volume==TRUE`.\n"
      ))
    }
    if (!is.null(resamp_res)) {
      warning(paste(
        "Resampling is not possible with the flat method.",
        "Ignoring `resamp_res`.\n"
      ))
    }
    return( read_cifti_flat(cifti_fname, wb_path=wb_path) )
  }

  # ----------------------------------------------------------------------------
  # Check arguments. -----------------------------------------------------------
  # ----------------------------------------------------------------------------

  require_separate_method <- full_volume || !is.null(resamp_res)

  brainstructures <- match_input(
    brainstructures, c("left","right","subcortical","all"),
    user_value_label="brainstructures"
  )
  if ("all" %in% brainstructures) { 
    brainstructures <- c("left","right","subcortical")
  }

  # ----------------------------------------------------------------------------
  # Read. ----------------------------------------------------------------------
  # ----------------------------------------------------------------------------

  if (!require_separate_method) {
    return(read_cifti_convert(
      cifti_fname,
      surfL_fname=surfL_fname, surfR_fname=surfR_fname,
      brainstructures=brainstructures, 
      wb_path=wb_path, verbose=verbose,
      ...
    ))

  } else {
    return(read_cifti_separate(
      cifti_fname,
      surfL_fname=surfL_fname, surfR_fname=surfR_fname,
      brainstructures=brainstructures, 
      resamp_res=resamp_res, sphereL_fname=sphereL_fname, sphereR_fname=sphereR_fname,
      wb_path=wb_path, verbose=verbose,
      ...
    ))
  }
}

#' @rdname read_cifti
#' @export
readCIfTI <- readcii <- read_xifti <- function(
  cifti_fname, flat=FALSE,
  surfL_fname=NULL, surfR_fname=NULL,
  brainstructures=c("left","right"), 
  full_volume=FALSE,
  resamp_res=NULL, sphereL_fname=NULL, sphereR_fname=NULL,
  wb_path=NULL, verbose=verbose, ...){

  read_cifti(
    cifti_fname, flat,
    surfL_fname, surfR_fname,
    brainstructures, 
    full_volume,
    resamp_res, sphereL_fname, sphereR_fname,
    wb_path, verbose, ...
  )
}