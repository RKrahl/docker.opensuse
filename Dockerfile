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
	dracut kmod udev \
	patch:openSUSE-2016-306 \
	patch:openSUSE-2016-360 \
	patch:openSUSE-2016-640 \
	patch:openSUSE-2016-648 \
	patch:openSUSE-2016-678 && \
    ( zypper --non-interactive install -t patch openSUSE-2016-580 || \
      (($? == 103)) ) && \
    zypper --non-interactive install -t patch \
	openSUSE-2016-346 \
	openSUSE-2016-392 \
	openSUSE-2016-472 \
	openSUSE-2016-474 \
	openSUSE-2016-476 \
	openSUSE-2016-523 \
	openSUSE-2016-529 \
	openSUSE-2016-534 \
	openSUSE-2016-559 \
	openSUSE-2016-564 \
	openSUSE-2016-583 \
	openSUSE-2016-612 \
	openSUSE-2016-647 \
	openSUSE-2016-680 \
	openSUSE-2016-681 \
	openSUSE-2016-695 \
	openSUSE-2016-697 \
	openSUSE-2016-733 \
	openSUSE-2016-735 && \
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
