#!/usr/bin/env Rscript

## begin warning handler
withCallingHandlers({

library(methods) # Because Rscript does not always do this

options('useFancyQuotes' = FALSE)

suppressPackageStartupMessages(library("optparse"))
suppressPackageStartupMessages(library("RGalaxy"))


option_list <- list()

option_list$CommunityFile <- make_option('--CommunityFile', type='character')
option_list$Attributes <- make_option('--Attributes', type='character')
option_list$OrdinationAlgorithm <- make_option('--OrdinationAlgorithm', type='character')
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
do.call(reducedDimensionality, params)

## end warning handler
}, warning = function(w) {
    cat(paste("Warning:", conditionMessage(w), "\n"))
    invokeRestart("muffleWarning")
})
