FROM opensuse:42.2

# Do some sanitization to the library image:
# * We don't want any non-oss packages in the image, so disable this
#   repo right away.
# * Not all package dependencies in the opensuse image are fulfilled
#   and some of the needed packages are not useful in a docker
#   container.  Lock them out to be sure they don't get inadvertly
#   installed later on.
# * Remove kmod-compat.  As kmod is not installed, it only contains
#   broken symbol links.
# * Apply patches that are not (yet?) in the library image.
# * Add a few very basic packages that make life easier along with
#   python-base and python-psutil needed by the init script.

RUN zypper --non-interactive modifyrepo --disable non-oss update-non-oss && \
    rpm --erase --nodeps kmod-compat && \
    zypper --non-interactive addlock \
	dracut kmod udev && \
    zypper --non-interactive install -t patch \
	openSUSE-2017-663 \
	openSUSE-2017-681 \
	openSUSE-2017-687 && \
    zypper --non-interactive install \
	aaa_base \
	curl \
	logrotate \
	pwgen \
	timezone \
	which

RUN zypper --non-interactive addrepo http://download.opensuse.org/repositories/home:/Rotkraut:/Docker/openSUSE_Leap_42.2/home:Rotkraut:Docker.repo && \
    zypper --non-interactive modifyrepo --priority 150 home_Rotkraut_Docker && \
    zypper --non-interactive --gpg-auto-import-keys refresh home_Rotkraut_Docker && \
    zypper --non-interactive install tiny-init && \
    zypper --non-interactive modifyrepo --disable home_Rotkraut_Docker

ENTRYPOINT ["/usr/sbin/tiny-init"]
