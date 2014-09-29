#!/bin/bash

[ -d shibsso-build ] && rm -rf shibsso-build
mkdir -p shibsso-build/temp
cd shibsso-build/temp
svn export https://svn.cern.ch/reps/elfmsdjango/shibsso-rpm/trunk shibsso-rpm
svn export https://svn.cern.ch/reps/elfmsdjango/shibsso/trunk django-shibsso
svn export https://github.com/sbel/shibsso-patch/trunk/patches
patch -p0 -d django-shibsso/ -i ../patches/shibsso-django16.patch
patch -p0 -d shibsso-rpm -i ../patches/shibsso-rpm.patch
mv django-shibsso django-shibsso-0.2
tar -cf django-shibsso-0.2.tar django-shibsso-0.2
cd shibsso-rpm
tar --append --file=../django-shibsso-0.2.tar django-shibsso.spec
cd ..
gzip django-shibsso-0.2.tar
cd ..
mkdir rpm-build
for d in BUILD  BUILDROOT  RPMS  SOURCES  SPECS  SRPMS; do mkdir rpm-build/$d; done
rpmbuild  -tb --define "_topdir `pwd`/rpm-build" temp/django-shibsso-0.2.tar.gz

echo -e "\n\n"
echo "RPM is in '`pwd`/rpm-build/RPMS/noarch'"
cd - >/dev/null

