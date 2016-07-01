FROM opensuse

# Do some sanitization to the library image:
# * We don't want any non-oss packages in the image, so disable this
#   repo right away.
# * Not all package dependencies in the opensuse image are fulfilled
#   and some of the needed packages are not useful in a docker
#   container.  Lock them out to be sure they don't get inadvertly
#   installed later on.
# * Apply patches that are not (yet?) in the library image.
# * Add a few very basic packages that make life easier along with
#   python-base and python-psutil needed by the init script.

RUN zypper --non-interactive modifyrepo --disable non-oss update-non-oss && \
    zypper --non-interactive addlock \
	dracut kmod udev && \
    zypper --non-interactive install -t patch \
	openSUSE-2016-773 \
	openSUSE-2016-814 && \
    zypper --non-interactive install \
	aaa_base \
	curl \
	which \
	python-base \
	python-psutil

RUN curl --silent --show-error --location \
	--output /usr/local/sbin/init \
	https://raw.githubusercontent.com/RKrahl/init/master/init.py && \
    chmod 0755 /usr/local/sbin/init

ENTRYPOINT ["/usr/local/sbin/init"]
