$dirs = Get-ChildItem 
foreach($dir in $dirs){
	echo $dir
	cd $dir.Name
	git status
	cd ..
}
