#' Download taxonomic databases
#'
#' @export
#' @name db_download
#' @param verbose (logical) Print messages. Default: \code{TRUE}
#'
#' @return Path to the downloaded SQL database
#' @details Downloads sql database, cleans up unneeded files, returns path to sql file
#'
#' @section Supported:
#' \itemize{
#'  \item ITIS - PostgreSQL
#'  \item the PlantList - PostgreSQL
#'  \item Catalogue of Life - MySQL
#' }
#'
#' @section Beware:
#' COL database loading takes a long time, e.g., 30 minutes. you may
#' want to run it in a separate R session, or just look at the db_load_col fxn
#' and run the commands in your shell.
#'
#' @examples \dontrun{
#' # ITIS
#' #db_download_itis() %>% db_load_itis()
#' x <- db_download_itis()
#' db_load_itis(x)
#'
#' # the plant list
#' #db_download_tpl() %>% db_load_tpl()
#' x <- db_download_tpl()
#' db_load_tpl(x)
#'
#' # catalogue of life
#' #db_download_col() %>% db_load_col()
#' x <- db_download_col()
#' db_load_col(x)
#' }

#' @export
#' @rdname db_download
db_download_itis <- function(verbose = TRUE){
  # paths
  itis_db_url <- 'http://www.itis.gov/downloads/itisPostgreSql.zip'
  itis_db_path <- path.expand('~/.taxize_local/itisPostgreSql.zip')
  itis_db_path_file <- path.expand('~/.taxize_local/itisPostgreSql')
  itis_final_file <- path.expand('~/.taxize_local/ITIS.sql')
  # make home dir if not already present
  mkhome(path.expand('~/.taxize_local/'))
  # download data
  mssg(verbose, 'downloading...')
  curl::curl_download(itis_db_url, itis_db_path, quiet = TRUE)
  # unzip
  mssg(verbose, 'unzipping...')
  unzip(itis_db_path, exdir = itis_db_path_file)
  # get file path
  dirs <- list.dirs(itis_db_path_file, full.names = TRUE)
  dir_date <- dirs[ dirs != itis_db_path_file ]
  db_path <- list.files(dir_date, pattern = ".sql", full.names = TRUE)
  # move database
  file.rename(db_path, itis_final_file)
  # cleanup
  mssg(verbose, 'cleaning up...')
  unlink(itis_db_path)
  unlink(itis_db_path_file, recursive = TRUE)
  # return path
  return( itis_final_file )
}

#' @export
#' @rdname db_download
db_download_tpl <- function(verbose = TRUE){
  # paths
  db_url <- 'https://github.com/ropensci/taxizedbs/blob/master/theplantlist/plantlist.zip?raw=true'
  db_path <- path.expand('~/.taxize_local/plantlist.zip')
  db_path_file <- path.expand('~/.taxize_local/plantlist')
  final_file <- path.expand('~/.taxize_local/plantlist.sql')
  # make home dir if not already present
  mkhome(path.expand('~/.taxize_local/'))
  # download data
  mssg(verbose, 'downloading...')
  curl::curl_download(db_url, db_path, quiet = TRUE)
  # unzip
  mssg(verbose, 'unzipping...')
  unzip(db_path, exdir = db_path_file)
  # move database
  file.rename(file.path(db_path_file, "plantlist.sql"), final_file)
  # cleanup
  mssg(verbose, 'cleaning up...')
  unlink(db_path)
  unlink(db_path_file, recursive = TRUE)
  # return path
  return( final_file )
}

#' @export
#' @rdname db_download
db_download_col <- function(verbose = TRUE){
  # paths
  #db_url <- 'http://www.catalogueoflife.org/services/res/AnnualChecklist2013-Linux.zip'
  db_url <- 'http://www.catalogueoflife.org/services/res/col2015ac_linux.tar.gz'
  db_path <- path.expand('~/.taxize_local/col2015ac_linux.tar.gz')
  db_path_file <- path.expand('~/.taxize_local/colmysql')
  db_sql_path <- path.expand('~/.taxize_local/colmysql/col2015ac_linux/col2015ac.sql.tar.gz')
  db_sql_out <- path.expand('~/.taxize_local/colmysql/col2015ac_linux')
  final_file <- path.expand('~/.taxize_local/col.sql')
  # make home dir if not already present
  mkhome(path.expand('~/.taxize_local/'))
  # download data
  mssg(verbose, 'downloading...')
  curl::curl_download(db_url, db_path, quiet = TRUE)
  # unzip
  mssg(verbose, 'unzipping...')
  #unzip(db_path, exdir = db_path_file)
  untar(db_path, exdir = db_sql_out)
  untar(db_sql_path, exdir = db_sql_out)
  # move database
  file.rename(file.path(db_sql_out, "col2015ac.sql"), final_file)
  # cleanup
  mssg(verbose, 'cleaning up...')
  unlink(db_path)
  unlink(db_path_file, recursive = TRUE)
  return( final_file )
}

## some code tried to use to convert COL mysql db to postgresql, didn't work
# mysqldump --compatible=postgresql --default-character-set=utf8 -r col.mysql -u root col2014ac
# python db_converter.py col.mysql col.psql
# psql -f col.psql