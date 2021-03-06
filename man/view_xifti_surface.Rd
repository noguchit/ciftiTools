% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/view_xifti.R
\name{view_xifti_surface}
\alias{view_xifti_surface}
\alias{view_cifti_surface}
\title{Visualize "xifti" cortical data. The \code{rgl} package is required.}
\usage{
view_xifti_surface(
  xifti,
  idx = 1,
  hemisphere = NULL,
  view = c("both", "lateral", "medial"),
  mode = c("widget", "image", "video"),
  width = NULL,
  height = NULL,
  bg = NULL,
  title = NULL,
  text_color = "black",
  fname = "xifti",
  write_dir = NULL,
  colors = NULL,
  color_mode = c("sequential", "qualitative", "diverging"),
  color_values = NULL,
  surfL = NULL,
  surfR = NULL,
  colorbar_embedded = TRUE,
  colorbar_digits = NULL
)

view_cifti_surface(
  xifti,
  idx = 1,
  hemisphere = NULL,
  view = c("both", "lateral", "medial"),
  mode = c("widget", "image", "video"),
  width = NULL,
  height = NULL,
  bg = NULL,
  title = NULL,
  fname = "xifti",
  write_dir = NULL,
  colors = NULL,
  color_mode = c("sequential", "qualitative", "diverging"),
  color_values = NULL,
  surfL = NULL,
  surfR = NULL,
  colorbar_embedded = TRUE,
  colorbar_digits = NULL
)
}
\arguments{
\item{xifti}{Object of class "xifti". 
See \code{\link{is.xifti}} and \code{\link{make_xifti}}.}

\item{idx}{The time/column index of the xifti data to plot. 
Currently one a single time point is supported. Default: the first index.}

\item{hemisphere}{Which brain cortex to display: "both", "left", or "right". 
If \code{NULL} (default), each available surface (e.g. if \code{surfL}
or \code{xifti$surf$cortex_right} is not empty) will be displayed. Surfaces without
data (e.g. \code{xifti$CORTEX_LEFT} is empty) will still be displayed,
colored by \code{color_NA}. Each cortex will be shown in a separate panel
column within the RGL window.}

\item{view}{Which view to display: "lateral", "medial", or "both". 
If \code{NULL} (default), both views will be shown. Each view
will be shown in a separate panel row within the RGL window.}

\item{mode}{One of "widget" (Default), "image", or "video":

 "widget" will open an interactive RGL window. Left click and drag to rotate.
 Use the scroll wheel to zoom. Run the R function 
 \code{rgl::snapshot("my_file.png")} to save the RGL window as a png. 
 See \code{\link[rgl]{snapshot}} for more information.
 
 "image" will open the RGL window, take a screenshot using
 \code{\link[rgl]{snapshot}}, and close it. The screenshot will be saved
 as a png in \code{write_dir} and its name will be \code{fname}.

 "video" will take a series of screenshots of the RGL window, while 
 rotating the brain surface(s), saving each to a file in \code{write_dir} 
 named by \code{fname}, and then close the RGL window. The frames can 
 be converted to a video file using multimedia software such as Adobe 
 Premiere Pro. The "video" mode is not yet supported.}

\item{width, height}{The dimensions of the RGL window, in pixels. If both are 
\code{NULL} (default), the dimensions will be set to 
1000 (width) x 700 (height) for 1x1 and 2x2 subplots,
1500 x 525 for 2x1 subplots, and
500 x 700 for 1x2 subplots. These defaults are chosen to fit comfortably
within a 1600 x 900 screen. Specyfing only one will set the other to maintain
the same aspect ratio. Both could be specified to set the dimensions exactly.}

\item{bg}{Background color. \code{NULL} will not color the background (white).}

\item{title}{Optional title for the plot. It will be printed at the top in
a separate subplot with 1/4 the height of the brain cortex subplots.
\code{NULL} (default) will not make a title.}

\item{text_color}{Color for text in title and colorbar legend. Default: 
"black".}

\item{fname}{An identifier to use for naming the saved images 
("[fname].png") and video frames ("[fname]_1.png", "[fname]_2.png", ...).
Default: "xifti".}

\item{write_dir}{Where should any output images be written. NULL (default) 
 will write them to the current working directory. 

 \code{write_dir} must already exist, or an error will occur.}

\item{colors}{(Optional) "ROY_BIG_BL", vector of colors to use, 
OR the name of a ColorBrewer palette (see RColorBrewer::brewer.pal.info 
and colorbrewer2.org). Defaults are \code{"ROY_BIG_BL"} (sequential), 
\code{"Set2"} (qualitative), and \code{"ROY_BIG_BL"} (diverging).
See the \code{ciftiTools::make_color_pal()} description for more details.}

\item{color_mode}{(Optional) \code{"sequential"}, \code{"qualitative"}, 
or \code{"diverging"}. Default: sequential. See the
\code{ciftiTools::make_color_pal()} description for more details.}

\item{color_values}{(Optional) Controls the mapping of values to each 
color in \code{colors}. If the length is longer than
one, using -Inf will set the value to \code{DATA_MIN}, and Inf will set 
the value to \code{DATA_MAX}. See the
\code{ciftiTools::make_color_pal()} description for more details.}

\item{surfL, surfR}{(Optional if \code{xifti$surf$cortex_left} and 
\code{xifti$surf$cortex_right} are not empty) The brain surface model to use. 
Each can be a file path for a GIFTI, a file read by gifti::readgii, 
or an object of class "xifti_surface". If provided, they will override 
\code{xifti$surf$cortex_left} and \code{xifti$surf$cortex_right} if they exist. 
Otherwise, leave these arguments as \code{NULL} (default) to use 
\code{xifti$surf$cortex_left} and \code{xifti$surf$cortex_right}.}

\item{colorbar_embedded}{Should the colorbar be embedded in the RGL window?
It will be positioned in the bottom-left corner, in a separate subplot 
with 1/4 the height of the brain cortex subplots. Default: \code{TRUE}.
If \code{FALSE}, print it separately instead.}

\item{colorbar_digits}{The number of digits for the colorbar legend ticks. 
If \code{NULL} (default), let \code{\link{format}} decide.}
}
\description{
Visualize "xifti" cortical data. The \code{rgl} package is required.
}
