#!/usr/bin/env Rscript

## begin warning handler
withCallingHandlers({

library(methods) # Because Rscript does not always do this

options('useFancyQuotes' = FALSE)

suppressPackageStartupMessages(library("optparse"))
suppressPackageStartupMessages(library("RGalaxy"))


option_list <- list()

option_list$CountsFile <- make_option('--CountsFile', type='character')
option_list$SamplesFile <- make_option('--SamplesFile', type='character')
option_list$K <- make_option('--K', type='numeric')
option_list$A <- make_option('--A', type='numeric')
option_list$Transform <- make_option('--Transform', type='character')
option_list$SampleName <- make_option('--SampleName', type='character')
option_list$ColumnClasses <- make_option('--ColumnClasses', type='character')
option_list$OutputFile <- make_option('--OutputFile', type='character')


opt <- parse_args(OptionParser(option_list=option_list))

suppressPackageStartupMessages(library(microbiomePkg))

## function body not needed here, it is in package

params <- list()
for(param in names(opt))
{
    if (!param == "help")
        params[param] <- opt[param]
}

setClass("GalaxyRemoteError", contains="character")
wrappedFunction <- function(f)
{
    tryCatch(do.call(f, params),
        error=function(e) new("GalaxyRemoteError", conditionMessage(e)))
}


suppressPackageStartupMessages(library(RGalaxy))
do.call(community, params)

## end warning handler
}, warning = function(w) {
    cat(paste("Warning:", conditionMessage(w), "\n"))
    invokeRestart("muffleWarning")
})
