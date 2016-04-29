FROM opensuse

RUN zypper --non-interactive modifyrepo --disable non-oss update-non-oss
RUN zypper --non-interactive install \
	curl \
	python-base \
	python-psutil

RUN curl --silent --show-error --location \
	--output /usr/local/sbin/init \
	https://raw.githubusercontent.com/RKrahl/init/master/init.py && \
    chmod 0755 /usr/local/sbin/init

ENTRYPOINT ["/usr/local/sbin/init"]
