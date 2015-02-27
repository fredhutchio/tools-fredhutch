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
option_list$OutputFile <- make_option('--OutputFile', type='character')


opt <- parse_args(OptionParser(option_list=option_list))

suppressPackageStartupMessages(library(RSclient))

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


c <- RS.connect(host='localhost', port=6311)
RS.eval(c, options('useFancyQuotes' = FALSE))
RS.eval(c, suppressPackageStartupMessages(library(RGalaxy)))
RS.assign(c, 'params', params)
RS.assign(c, 'wrappedFunction', wrappedFunction)
RS.eval(c, setClass('GalaxyRemoteError', contains='character'))
res <- RS.eval(c, wrappedFunction(descriptiveStatistics))
RS.close(c)
if(is(res, 'GalaxyRemoteError'))RGalaxy::gstop(res)

## end warning handler
}, warning = function(w) {
    cat(paste("Warning:", conditionMessage(w), "\n"))
    invokeRestart("muffleWarning")
})
