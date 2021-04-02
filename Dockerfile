FROM opensuse/leap:15.3

# Do some sanitization to the library image:
# * We don't want any non-oss packages in the image, so disable this
#   repo right away.
# * Add systemd.  This package is not needed by this image, but more
#   or less all packages for server applications require it nowadays,
#   so it makes sense to have it in the common base package.
# * Apply patches.
# * Add a few very basic packages that make life easier along with
#   python-base and python-psutil needed by the init script.

RUN zypper --non-interactive modifyrepo \
	--disable "repo-non-oss" "repo-update-non-oss" && \
    ( zypper --non-interactive patch || \
        ((test $? == 103) && zypper --non-interactive patch )) && \
    zypper --non-interactive install \
	curl \
	file \
	glibc-locale \
	pwgen \
	timezone \
	which

RUN zypper --non-interactive addrepo https://download.opensuse.org/repositories/home:/Rotkraut:/Docker/openSUSE_Leap_15.3/home:Rotkraut:Docker.repo && \
    zypper --non-interactive --gpg-auto-import-keys refresh home_Rotkraut_Docker && \
    zypper --non-interactive install tiny-init && \
    zypper --non-interactive modifyrepo --disable home_Rotkraut_Docker

ENTRYPOINT ["/usr/sbin/tiny-init"]
