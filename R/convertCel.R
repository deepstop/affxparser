#########################################################################/**
# @RdocFunction convertCel
#
# @title "Converts a CEL into the same CEL but with another format"
#
# @synopsis 
# 
# \description{
#   @get "title".  
#   Currently only CEL files in version 4 (binary/XDA) can be written.
#   However, any input format is recognized.
# }
# 
# \arguments{
#   \item{filename}{The pathname of the original CEL file.}
#   \item{outFilename}{The pathname of the destination CEL file.
#     If the same as the source file, an exception is thrown.}
#   \item{readMap}{An optional read map for the input CEL file.}
#   \item{writeMap}{An optional write map for the output CEL file.}
#   \item{version}{The version of the output file format.}
#   \item{...}{Not used.}
#   \item{.validate}{If @TRUE, a consistency test between the generated 
#     and the original CDF is performed.  Note that the memory overhead
#     for this can be quite large, because two complete CDF structures 
#     are kept in memory at the same time.}
#   \item{verbose}{If @TRUE, extra details are written while processing.}
# }
# 
# \value{
#   Returns (invisibly) @TRUE if a new CEL was generated, otherwise @FALSE.
# }
#
# \section{Benchmarking of ASCII and binary CELs}{
#   Binary CELs are much faster to read than ASCII CELs.  Here are some
#   example for reading complete CELs (the differnce is even larger when
#   reading CELs in subsets):
#   \itemize{
#     \item To do
#   }
# }
#
# @author
#
# \seealso{
#   @see "createCel".
# }
#
# @keyword "file"
# @keyword "IO"
#*/#########################################################################
convertCel <- function(filename, outFilename, readMap=NULL, writeMap=NULL, version="4", ..., .validate=FALSE, verbose=FALSE) {
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Validate arguments
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Argument 'filename':
  # Expand any '~' in the pathname.
  filename <- file.path(dirname(filename), basename(filename));
  if (!file.exists(filename)) {
    stop("Cannot open CEL file. File does not exist: ", filename);
  }

  # Argument 'outFilename':
  # Expand any '~' in the pathname.
  outFilename <- file.path(dirname(outFilename), basename(outFilename));
  if (identical(outFilename, filename)) {
    stop("Cannot convert CEL file. Destination is identical the the source pathname: ", filename);
  }
  if (file.exists(outFilename)) {
    stop("Cannot convert CEL file. Destination file already exists: ", filename);
  }

  # Argument 'version':
  version <- as.character(version);
  if (version == "4") {
  } else {
    stop("Cannot convert CEL. Currently only version 4 (binary/XDA) can be written: ", version);
  }

  # Argument 'verbose':
  verbose <- as.integer(verbose);

  verbose2 <- verbose-1;
  if (verbose2 < 0) verbose2 <- 0;


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Read source CEL
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if (verbose)
    cat("Reading CEL file...\n");
    cel <- readCel(filename, readHeader=TRUE, readXY=TRUE, readIntensities=TRUE, readStdvs=TRUE, readPixels=TRUE, readOutliers=FALSE, readMasked=FALSE, readMap=readMap);
  if (verbose)
    cat("Reading CEL file...done\n");


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Creating new CEL file
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if (verbose)
    cat("Creating empty CEL file...\n");
  cel$header$version <- 4;
  pathname <- createCel(outFilename, header=cel$header, overwrite=FALSE, verbose=verbose2);
  if (verbose)
    cat("Creating empty CEL file...done\n");


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Update destination CEL file
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if (verbose)
    cat("Updating CEL file...\n");
  indices <- cel$y*cel$header$cols + cel$x + 1;
  if (!is.null(readMap)) {
    indices <- readMap[indices];
  }
  updateCel(outFilename, intensities=cel, verbose=verbose2, writeMap=writeMap);
  if (verbose)
    cat("Updating CEL file...done\n");

  if (.validate) {
    if (verbose)
      cat("Validating CEL file...\n");
    otherReadMap <- NULL;
    if (!is.null(writeMap))
      otherReadMap <- invertMap(writeMap);
    compareCels(filename, outFilename, readMap=readMap, 
                                otherReadMap=otherReadMap, verbose=verbose);
    if (verbose)
      cat("Validating CEL file...done\n");
  }

  invisible(pathname);
} # convertCel()


############################################################################
# HISTORY:
# 2007-01-04
# o Creates identical output according to validateCels().
# o Added 'readMap' and 'writeMap' arguments.
# 2007-01-03
# o Created.
############################################################################