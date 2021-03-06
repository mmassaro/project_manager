#                                      _
#                      _o)   __ _  ___/ /__  __ _  (o_
####################   /\\  /  ' \/ _  / _ `/  ' \ //\   #####################
#                      \_v /_/_/_/\_,_/\_, /_/_/_/ v_/
#                                     /___/
#
# Author:       Michel Massaro
# Version :     V0.1
# Date :        30/01/17
# Description : projet for latex
#
##############################################################################


_contains(){
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}


_create_sconstruct(){
    local DIR=$1
    if [ ! -f $DIR/sconstruct ]; then
        touch $DIR/sconstruct
        echo "import os" >> $DIR/sconstruct
        echo "env=Environment()" >> $DIR/sconstruct
        echo "env.AppendUnique(PDFLATEXFLAGS='-shell-escape')" >> $DIR/sconstruct
        echo "env.PDF('toto.tex')" >> $DIR/sconstruct
    fi
}


_check_args(){
  if [[ $# -ge 2 ]] && [[ ${1:0:1} != "-"  ]]; then
    local available_type=("article" "beamer" "letter" "poster" "thesis")
    if ! _contains "$2" ${available_type[@]}; then return 1; fi
    return 0
  fi
  return 1
}




new_project(){

# function_name : new_project
# description : "Create a full template for a project LaTeX"
# example : "new_project projectName article"
# example : "new_project projectName thesis -author \"Jane Doe\" "
# example : "new_project projectName beamer"
# option : -h "Display this manual" DEFAULT = "NONE"
# option : -author "Author name" DEFAULT = "John Doe"
# option : -fins "Path of file.ins with general informations on author in a letter" DEFAULT = "NONE"
# option : -fname "Name of the document" DEFAULT = "NONE"


  # Need help ?
  _contains "-h" $@
  if [ "$?" = "0" ]; then
    func_man new_project
    return 1
  fi

  projectName=$1
  projectType=$2

  # Check arguments
  INSTALL_DIR=.
  if ! _check_args $@; then 
    printf "\nERROR : Wrong list of parameter:\n"
    func_man new_project
    return 1
  fi

  # This function search and set the optionnal arguments
  if ! set_args new_project $@; then 
    return 1
  fi


  # Create the directory
  if [ ! -d $INSTALL_DIR/$projectName ]; then
    mkdir $INSTALL_DIR/$projectName

    if command -v scons >/dev/null 2>&1 ; then
      _create_sconstruct $INSTALL_DIR/$projectName
    fi

    cp $PMNG/projects/enable/latex/templates/$projectType/* "$INSTALL_DIR/$projectName/"



    case $projectType in
      letter) _create_letter;;
      thesis) echo "ceci est une these";;
      article) _create_article;;
      beamer)  echo "ceci est une presentation";;
      poster)  echo "ceci est un poster"
    esac

  fi

}

_create_letter(){
  local filename="sample_letter"
  if [ ! "$mfname" = "NONE" ]; then
    filename=$mfname
    mv $INSTALL_DIR/$projectName/sample_letter.tex $INSTALL_DIR/$projectName/$filename.tex
  fi
  if [ -f $INSTALL_DIR/$projectName/sconstruct ]; then
    sed "s/toto.tex/$filename.tex/g" $INSTALL_DIR/$projectName/sconstruct > tmp
    mv tmp $INSTALL_DIR/$projectName/sconstruct
  fi

  if [ ! "$mfins" = "NONE" ]; then
    rm $INSTALL_DIR/nomprenom.ins
    cp $mfins $INSTALL_DIR/nomprenom.ins
  fi
}


_create_article(){
  local filename="sample_article"
  if [ ! "$mfname" = "NONE" ]; then
    filename=$mfname
    mv $INSTALL_DIR/$projectName/sample_article.tex $INSTALL_DIR/$projectName/$filename.tex
  fi
  if [ -f $INSTALL_DIR/$projectName/sconstruct ]; then
    sed "s/toto.tex/$filename.tex/g" $INSTALL_DIR/$projectName/sconstruct > tmp
    mv tmp $INSTALL_DIR/$projectName/sconstruct
  fi

}

















##function to create a sconstruct for latex
#stex(){
#
#    if [ $# -eq 2 ]
#    then
#
#        mkdir ${2}_$1
#        cd ${2}_$1
#        mkdir images
#
#        touch sconstruct
#        echo "import os" >> sconstruct
#        echo "env=Environment()" >> sconstruct
#        echo "env.PDF('${1}.tex')" >> sconstruct
#
#        touch ${1}.tex
#
#        if [ $2 = "beamer" ]
#        then
#            cp ~/Documents/Bases_Latex/Perso/beamer_massaro.cls .
#
#            echo "% vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{{,}}} foldlevel=0 foldmethod=marker:" >> ${1}.tex
#            echo "" >> ${1}.tex
#            echo "\\documentclass{beamer_massaro}" >> ${1}.tex
#            echo "" >> ${1}.tex
#            echo "\\title{Title}" >> ${1}.tex
#            echo "\\date{}" >> ${1}.tex
#            echo "\\author[1]{Michel Massaro\\footnote{IRMA, 7 rue Ren\\'e Descartes," >> ${1}.tex
#            echo "67084 Strasbourg, France \\\\" >> ${1}.tex
#            echo "Email : massaro@math.unistra.fr}}" >> ${1}.tex
#            echo "" >> ${1}.tex
#            echo "\\begin{document}" >> ${1}.tex
#            echo "\\maketitle" >> ${1}.tex
#            echo "" >> ${1}.tex
#            echo "\\end{document}" >> ${1}.tex
#
#        elif [ $2 = "beamerposter" ]
#        then
#
#            echo "en construction"
#
#        elif [ $2 = "article" ]
#        then
#            cp ~/Documents/Bases_Latex/Perso/article_massaro.cls .
#
#            echo "% vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{{,}}} foldlevel=0 foldmethod=marker:" >> ${1}.tex
#            echo "" >> ${1}.tex
#            echo "\\documentclass{article_massaro}" >> ${1}.tex
#            echo "" >> ${1}.tex
#            echo "\\title{Title}" >> ${1}.tex
#            echo "\\date{}" >> ${1}.tex
#            echo "\\author[1]{Michel Massaro\\footnote{IRMA, 7 rue Ren\\'e Descartes," >> ${1}.tex
#            echo "67084 Strasbourg, France \\\\" >> ${1}.tex
#            echo "Email : massaro@math.unistra.fr}}" >> ${1}.tex
#            echo "" >> ${1}.tex
#            echo "\\begin{document}" >> ${1}.tex
#            echo "\\maketitle" >> ${1}.tex
#            echo "" >> ${1}.tex
#            echo "\\end{document}" >> ${1}.tex
#        else
#            echo "Bad argument"
#            cd ..
#            rm -r ${2}_$1
#        fi
#    else
#        echo "Bad number argument"
#    fi
#}
#
## Function to manage a diary
#cdb(){
#    d=$(date +%d%m%Y-%H%M)
#    mkdir ~/Documents/TheseUHA/article_cdb/images/$d
#    sed -i '/end{document}/d' ~/Documents/TheseUHA/article_cdb/cdb.tex
#    echo "\\section{$d}" >> ~/Documents/TheseUHA/article_cdb/cdb.tex
#    echo "" >> ~/Documents/TheseUHA/article_cdb/cdb.tex
#    cat parametres >> ~/Documents/TheseUHA/article_cdb/cdb.tex
#    echo "" >> ~/Documents/TheseUHA/article_cdb/cdb.tex
#    if [ $# -eq 1 ]
#    then
#        cat $1 | awk '/\\incl/' | awk -vRS="}" -vFS="{" '{print $2}' | awk '/\.png/ || /\.pdf/ || /\.ps/' > tmp
#        while read line
#        do
#            cp $line ~/Documents/TheseUHA/article_cdb/images/$d/$(echo $line | sed 's/_/-/g')
#            sed -i "s/$line/images\/$d\/$line/g" comm
#        done < tmp
#
#        sed -i '/incl/s/_/-/g' $1
#        cat $1 >> ~/Documents/TheseUHA/article_cdb/cdb.tex
#    fi
#    echo "" >> ~/Documents/TheseUHA/article_cdb/cdb.tex
#    echo "\\end{document}" >> ~/Documents/TheseUHA/article_cdb/cdb.tex
#    rm tmp
#}


