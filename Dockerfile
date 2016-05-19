FROM opensuse

# We don't want any non-oss packages in the image, so disable this
# repo right away.  Not all package dependencies in the opensuse image
# are fulfilled and some of needed packages would cause problems in a
# docker container, so lock them out to be sure they don't get
# inadvertly installed later on.  Add a few very basic packages that
# make life easier along with python-base and python-psutil needed by
# the init script.

RUN zypper --non-interactive modifyrepo --disable non-oss update-non-oss && \
    zypper --non-interactive addlock dracut udev && \
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
