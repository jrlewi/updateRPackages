#Script to move all packages to newest version's libPath and then update

#do a brew update, if you have Homebrew installed
system('brew update && brew upgrade')

#Find all the current and past library paths
vrs_pth<-file.path('','Library', 'Frameworks', 'R.framework', 'Versions') #these are default mac paths R, you may need to change
versions<-dir(vrs_pth)[!dir(vrs_pth)=='Current']
o<-order(as.numeric(versions))
cur<-versions[max(o)]
old<-versions[-max(o)]
libs_new<-file.path(vrs_pth,cur, 'Resources', 'library')
#for each old library path, compare each of the libraries to the libraries in current version. Copy old to new if doesn't already exist.
sapply(old, function(oldnumber){
  libs_old<-file.path(vrs_pth,oldnumber, 'Resources', 'library')
  diff_libs<-setdiff(dir(libs_old),dir(libs_new))
  if(length(diff_libs)>0){
    sapply(diff_libs, function(x){
      file.rename(from=file.path(libs_old,x),to=file.path(libs_new,x))
    })
  }
})

#update packages
update.packages(ask=FALSE, type='source')


