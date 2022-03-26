#' import_pySCA_module_using_reticulate
#'
#' @param virtualenv Either the name of, or the path to, a Python virtual environment. NULL if you do not want to specify.
#' @param condaenv The name of the Conda environment to use. NULL if you do not want to specify.
#' @param force_installing A boolean, if true, will create an env  and install missing python modules.
#'
#' @return pySCA module
#' @export
#'
#' @examples
#' \dontrun{
#' library(reticulate)
#' use_virtualenv("~/myenv")
#' use_condaenv("myenv")
#' pysca <- import_pySCA_module_using_reticulate
#' pysca$scaTools
#' }
import_pySCA_module_using_reticulate <- function(
  virtualenv = NULL,
  condaenv = NULL,
  force_installing = FALSE){
  if (!requireNamespace("reticulate", quietly = TRUE)) {
    stop(
      "Package \"reticulate\" must be installed to use this function.",
      call. = FALSE
    )
  }

  if (!is.null(condaenv)) { #using conda
    if (force_installing) { #creating conda env
      reticulate::conda_create(condaenv, forge = TRUE, python_version = "3")
    }
    reticulate::use_condaenv(condaenv)
  } else if (!is.null(virtualenv)) { #using virtual env
    if (force_installing) { #creating virtual env
      reticulate::virtualenv_create(virtualenv, python_version = "3")
    }
    reticulate::use_virtualenv(virtualenv)
  }
  if (force_installing) {
    reticulate::py_install(c("numpy", "pandas", "scipy",
      "matplotlib", "Bio", "biopython "),pip = TRUE )
  }


  # Check if Python is available on this system
  #if(!reticulate::py_available(initialize = FALSE))
  #  stop(paste0("Python isn't available on this system. Please try to use ",
  #  "virtualenv = 'my-env' or condaenv = 'my-env' and ",
  #  "force_py_install = TRUE and force_create_env = TRUE if it does not exist"))
  # Check if a Python modules are available on this system.
  if(!reticulate::py_module_available("numpy"))
    stop("'numpy' isn't available on this system.")
  if(!reticulate::py_module_available("pandas"))
    stop("'pandas' isn't available on this system.")
  if(!reticulate::py_module_available("scipy"))
    stop("'scipy' isn't available on this system.")
  if(!reticulate::py_module_available("matplotlib"))
    stop("'matplotlib' isn't available on this system.")
  if(!reticulate::py_module_available("Bio"))
    stop("'Bio' isn't available on this system.")

  path <- system.file("python", package = "toolkit4pySCA")
  if(length(path) == 0)
    stop("There was a failure trying to find the pysca module inside the toolkit4pySCA package.")

  reticulate::import_from_path("pysca", path = path,
    convert = TRUE, delay_load = FALSE) %>%
    return()
}
