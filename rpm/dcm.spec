Name: dcm
Version: %{version}
Release: 0
Summary: data capture module, rsync+ssh
Source: dcm-%{version}.tar.gz
BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-${version}
License: proprietary
Requires: python python-pip python-dateutil redis lighttpd openssh-server openssh-clients rsync perl-Digest-SHA m4 jq rssh sudo zip
%description 
data capture module, deposition protocol rsync+ssh protocol

%prep
#rm -rf $RPM_BUILD_DIR/dcm
#zcat $RPM_SOURCE_DIR/dcm-0.1.tar.gz | tar -xvf -
%setup -c -n dcm

%build
# empty - no compile needed

%pre
geteng group upload || groupadd upload

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/opt/dcm/
mkdir -p %{buildroot}/etc/dcm

cp -r api %{buildroot}/opt/dcm
cp -r gen %{buildroot}/opt/dcm
cp -r scn %{buildroot}/opt/dcm
cp -r lib %{buildroot}/opt/dcm
mkdir -p %{buildroot}/deposit/requests
mkdir -p %{buildroot}/deposit/gen
mkdir -p %{buildroot}/deposit/processed
mkdir -p %{buildroot}/hold/requests
mkdir -p %{buildroot}/hold/stage
cp requirements.txt %{buildroot}/opt/dcm/
cp doc/config/rq-init-d %{buildroot}/etc/dcm/rq-init-d
cp doc/config/lighttpd.conf %{buildroot}/etc/dcm/lighttpd-conf-dcm
cp doc/config/lighttpd-modules.conf %{buildroot}/etc/dcm/lighttpd-modules-dcm
cp doc/config/rssh.conf %{buildroot}/etc/dcm/dcm-rssh.conf
mkdir -p %{buildroot}/etc/sudoers.d
cp doc/config/sudoers-chage %{buildroot}/etc/sudoers.d/chage

%clean

rm -rf %{buildroot}

%files
/etc/dcm/rq-init-d
/etc/sudoers.d/chage
/etc/dcm/lighttpd-conf-dcm
/etc/dcm/lighttpd-modules-dcm
/etc/dcm/dcm-rssh.conf
/opt/dcm/api/*
/opt/dcm/gen/*
/opt/dcm/lib/*
/opt/dcm/scn/post_upload*.bash
/opt/dcm/requirements.txt
%dir %attr(0744,lighttpd,lighttpd) /deposit/requests
%dir %attr(0744,lighttpd,lighttpd) /deposit/gen
%dir %attr(0744,lighttpd,lighttpd) /deposit/processed
%dir %attr(0744,lighttpd,lighttpd) /hold/requests
%dir %attr(0744,lighttpd,lighttpd) /hold/stage
