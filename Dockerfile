FROM registry.opensuse.org/opensuse/leap:15.4

# Do some sanitization to the library image:
# * We don't want any non-oss packages in the image, so disable this
#   repo right away.
# * Apply patches.
# * Add a few very basic packages needed by most derived images.
# * Add the init script.

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

RUN zypper --non-interactive addrepo https://download.opensuse.org/repositories/home:/Rotkraut:/Docker/15.4/home:Rotkraut:Docker.repo && \
    zypper --non-interactive --gpg-auto-import-keys refresh home_Rotkraut_Docker && \
    zypper --non-interactive install tiny-init && \
    zypper --non-interactive modifyrepo --disable home_Rotkraut_Docker

ENTRYPOINT ["/usr/sbin/tiny-init"]
