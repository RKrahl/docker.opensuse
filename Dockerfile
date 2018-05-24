FROM opensuse/leap:15.0

# Do some sanitization to the library image:
# * We don't want any non-oss packages in the image, so disable this
#   repo right away.
# * Some package are not useful in a docker container but are marked
#   as dependencies of other packages.  Lock them out to be sure they
#   don't get inadvertly installed later on.
# * Apply patches.
# * Add a few very basic packages that make life easier along with
#   python-base and python-psutil needed by the init script.

RUN zypper --non-interactive modifyrepo \
	--disable "repo-non-oss" "repo-update-non-oss" && \
    zypper --non-interactive addlock \
        dracut kmod udev && \
    zypper --non-interactive patch && \
    zypper --non-interactive install \
	curl \
	file \
	pwgen \
	timezone \
	which

RUN zypper --non-interactive addrepo https://download.opensuse.org/repositories/home:/Rotkraut:/Docker/openSUSE_Leap_15.0/home:Rotkraut:Docker.repo && \
    zypper --non-interactive --gpg-auto-import-keys refresh home_Rotkraut_Docker && \
    zypper --non-interactive install tiny-init && \
    zypper --non-interactive modifyrepo --disable home_Rotkraut_Docker

ENTRYPOINT ["/usr/sbin/tiny-init"]
