#' Resample an individual GIFTI file (with its ROI)
#'
#' @description Performs spatial resampling of NIFTI/GIFTI data on the cortical 
#'  surface.
#'
#' @param original_fname The GIFTI file to resample.
#' @param target_fname Where to save the resampled file.
#' @param file_type \code{"metric"} or \code{"surface"}, or \code{NULL} 
#'  (default) to infer from \code{original_fname}.
#' @param ROIcortex_original_fname The name of the ROI file corresponding to 
#'  \code{original_fname}. Leave as \code{NULL} (default) if this doesn't exist
#'  or shouldn't be resampled.
#' @param validROIcortex_target_fname The name of the resampled ROI file. Only 
#'  applicable if \code{ROIcortex_original_fname} is provided.
#' @inheritParams resamp_res_Param_required
#' @param sphere_original_fname File path of [left/right]-hemisphere spherical 
#'  GIFTI files in original resolution. The hemisphere side should match that of
#'  \code{original_fname}.
#' @param sphere_target_fname File path of [left/right]-hemisphere spherical 
#'  GIFTI files in targetinal resolution. The hemisphere side should match 
#'  that of \code{target_fname}. See \code{\link{make_helper_spheres}}.
#' @param read_dir Directory to append to the path of every file name in
#'  \code{original_fname} and \code{ROIcortex_original_fname}. If \code{NULL} 
#'  (default), do not append any directory to the path. 
#' @param write_dir Directory to append to the path of every file name in
#'  \code{target_fname} and \code{validROIcortex_target_fname}. If \code{NULL} 
#'  (default), do not append any directory to the path. 
#' @inheritParams wb_path_Param
#'
#' @return Logical indicating whether resampled file was created.
#' @export
#'
resample_gifti <- function(original_fname, target_fname, file_type=NULL, 
  ROIcortex_original_fname=NULL, validROIcortex_target_fname=NULL,
  resamp_res, sphere_original_fname, sphere_target_fname, 
  read_dir=NULL, write_dir=NULL, wb_path=NULL) {

  # Check arguments.
  original_fname <- format_path(original_fname, read_dir, mode=4)
  stopifnot(file.exists(original_fname))
  do_ROI <- !is.null(ROIcortex_original_fname)
  if (do_ROI) {
    ROIcortex_original_fname <- format_path(
      ROIcortex_original_fname, read_dir, mode=4)
    stopifnot(file.exists(ROIcortex_original_fname))
  }
  target_fname <- format_path(target_fname, write_dir, mode=2)
  if (do_ROI) {
    validROIcortex_target_fname <- format_path(
      validROIcortex_target_fname, write_dir, mode=2)
  }
  if (is.null(file_type)) {
    if (grepl("func.gii", original_fname, fixed=TRUE)) { 
      file_type <- "metric" 
    } else if (grepl("surf.gii", original_fname, fixed=TRUE)) { 
      file_type <- "surface" 
    } else { 
      stop(paste(
        "Could not infer file type of ", original_fname, 
        ". Please set the file_type argument."
      )) 
    }
  }
  file_type <- match.arg(file_type, c("metric", "surface"))
  stopifnot(is.numeric(resamp_res))
  stopifnot(resamp_res > 0)
  sphere_original_fname <- format_path(sphere_original_fname)
  stopifnot(file.exists(sphere_original_fname))
  sphere_target_fname <- format_path(sphere_target_fname)
  stopifnot(file.exists(sphere_target_fname))
  if (do_ROI & file_type=="surface") { 
    stop("do_ROI AND file_type=='surface', but surface files do not use ROI.") 
  }

  cmd_name <- switch(file_type,
    metric="-metric-resample",
    surface="-surface-resample"
  )

  cmd <- paste(
    cmd_name, 
    sys_path(original_fname), sys_path(sphere_original_fname), 
    sys_path(sphere_target_fname), "BARYCENTRIC", sys_path(target_fname)
  )
  if (do_ROI) {
    cmd <- paste(
      cmd, "-current-roi", sys_path(ROIcortex_original_fname), 
      "-valid-roi-out", sys_path(validROIcortex_target_fname)
    )
  }
  run_wb_cmd(cmd, wb_path)
}

#' Resample a metric GIFTI file (ends with "func.gii")
#'
#' @param ... Arguments to \code{\link{resample_gifti}}. All except 
#'  \code{file_type} (which is "metric") can be provided.
#'
#' @return Logical indicating whether resampled file was created.
#' @export
#'
metric_resample <- function(...) {
  # Check that the arguments are valid.
  kwargs_allowed <- c("", get_kwargs(ciftiTools::resample_gifti))
  kwargs <- names(list(...))
  if ("file_type" %in% kwargs) { 
    stop(paste(
      "file_type==\"metric\" for metric_resample and therefore",
      "should not be provided as an argument."
    ))
  }
  stopifnot(all(kwargs %in% kwargs_allowed))

  resample_gifti(..., file_type="metric")
}

#' Resample a surface GIFTI file
#'
#' @param ... Arguments to \code{\link{resample_gifti}}. All except 
#'  \code{file_type} (which is "surface") can be provided.
#'
#' @return Logical indicating whether resampled file was created.
#' @export
#'
surface_resample <- function(...) {
  # Check that the arguments are valid.
  kwargs_allowed <- c("", get_kwargs(ciftiTools::resample_gifti))
  kwargs <- names(list(...))
  if ("file_type" %in% kwargs) { 
    stop(paste(
      "file_type==\"surface\" for surface_resample and therefore",
      "should not be provided as an argument."
    ))
  }
  stopifnot(all(kwargs %in% kwargs_allowed))

  resample_gifti(..., file_type="surface")
}

#' Generate GIFTI sphere surface files
#'
#' @description This function generates a pair of GIFTI vertex-matched left and 
#'  right spheres in the target resolution. These are required for resampling 
#'  CIFTI and GIFTI files. 
#'
#' @param sphereL_fname File path to left-hemisphere spherical GIFTI to be 
#'  created
#' @param sphereR_fname File path to right-hemisphere spherical GIFTI to be 
#'  created
#' @inheritParams resamp_res_Param_required
#' @param write_dir (Optional) directory to place the sphere files in. If
#'  \code{NULL} (default), do not append any directory to the sphere file paths.
#' @inheritParams wb_path_Param
#'
#' @return Logical indicating whether output files exist. 
#' @export
#'
make_helper_spheres <- function(
  sphereL_fname, sphereR_fname, resamp_res, 
  write_dir=NULL, wb_path=NULL) {

  sphereL_fname <- format_path(sphereL_fname, write_dir, mode=2)
  sphereR_fname <- format_path(sphereR_fname, write_dir, mode=2)

  run_wb_cmd(
    paste("-surface-create-sphere", resamp_res, sys_path(sphereL_fname)), 
    wb_path
  )
  run_wb_cmd(
    paste("-surface-flip-lr", sys_path(sphereL_fname), sys_path(sphereR_fname)), 
    wb_path
  )
  run_wb_cmd(
    paste("-set-structure", sys_path(sphereL_fname), "CORTEX_LEFT"), 
    wb_path
  )
  run_wb_cmd(
    paste("-set-structure", sys_path(sphereR_fname), "CORTEX_RIGHT"), 
    wb_path
  )

  invisible(file.exists(sphereL_fname) & file.exists(sphereR_fname))
}

#' @rdname resample_gifti
#' @export
resampleGIfTI <- resamplegii <- function(
  original_fname, target_fname, file_type=NULL, 
  ROIcortex_original_fname=NULL, validROIcortex_target_fname=NULL,
  resamp_res, sphere_original_fname, sphere_target_fname, 
  read_dir=NULL, write_dir=NULL, wb_path=NULL){

  resample_gifti(
    original_fname, target_fname, file_type, 
    ROIcortex_original_fname, validROIcortex_target_fname,
    resamp_res, sphere_original_fname, sphere_target_fname, 
    read_dir, write_dir, wb_path
  )
}