function lfig(arg, args...)
    file = dfname(arg, args...)
    FileIO.load(file)
end