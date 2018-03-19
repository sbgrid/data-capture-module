Name: dcm
Version: 0.1
Release: 0
Summary: data capture module, rsync+ssh
Source: dcm-0.1.tar.gz
BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-${version}
License: proprietary
Requires: python python-pip python-dateutil redis lighttpd openssh-server rsync perl-Digest-SHA m4 jq rssh
%description 
data capture module, deposition protocol rsync+ssh protocol

%prep
rm -rf $RPM_BUILD_DIR/dcm
zcat $RPM_SOURCE_DIR/dcm-0.1.tar.gz | tar -xvf -

%build
# empty - no compile needed

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/opt/dcm/
mkdir -p %{buildroot}/etc/dcm

cp -r api %{buildroot}/opt/dcm
cp -r gen %{buildroot}/opt/dcm
cp -r scn %{buildroot}/opt/dcm
mkdir -p %{buildroot}/deposit/requests
mkdir -p %{buildroot}/hold/requests
cp requirements.txt %{buildroot}/opt/dcm/
cp doc/config/rq-init-d %{buildroot}/etc/dcm/rq-init-d
cp doc/config/lighttpd.conf %{buildroot}/etc/dcm/lighttpd-conf-dcm
cp doc/config/lighttpd-modules.conf %{buildroot}/etc/dcm/lighttpd-modules-dcm

%clean

rm -rf %{buildroot}

%files
/etc/dcm/rq-init-d
/etc/dcm/lighttpd-conf-dcm
/etc/dcm/lighttpd-modules-dcm
/opt/dcm/api/*
/opt/dcm/gen/*
/opt/dcm/scn/post_upload.bash
/opt/dcm/requirements.txt
%dir /deposit/requests
%dir /hold/requests
