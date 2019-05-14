FROM ubuntu:16.04

# Download (1) packages we need to download the code (e.g. wget, git)
# and (2) packages needed by Qt

RUN apt-get update
RUN apt-get install -y \
			wget \
      git \
      xz-utils \
      libfontconfig \
      libdbus-1-dev \
      libx11-6 \
      libx11-xcb1 \
      mesa-common-dev \
      libgl1-mesa-dev \
      libxi6 \
      x11-xkb-utils \
      xkb-data

# Download a specific version of Qt
# Note: This may take some time. This file is > 1G.

RUN wget http://download.qt.io/archive/qt/5.9/5.9.7/qt-opensource-linux-x64-5.9.7.run

# Unpack and install Qt
# Note: This may take some time. It uses 100M of storage space. This warning
# can be ignored: "Unknown option: p, l, a, t, f, o, r, m"

COPY qt-noninteractive.qs /qt-noninteractive.qs
RUN chmod 755 qt-opensource-linux-x64-5.9.7.run
RUN /qt-opensource-linux-x64-5.9.7.run --script qt-noninteractive.qs  -platform minimal

# Download QtLing

RUN git clone https://github.com/JohnAGoldsmith/QtLing.git /QtLing

# Generate the QtLing Makefile

RUN /qt/5.9.7/gcc_64/bin/qmake -o /QtLing/QtLing/Makefile /QtLing/QtLing/QtLing.pro

# Build QtLing

RUN cd /QtLing/QtLing && make VERBOSE=1

RUN echo "# Execute QtLing\n\n$ cd /QtLing/QtLing && ./QtLing\n\n#Rebuild QtLing\n\n$ cd /QtLing/QtLing && make VERBOSE=1\n" > /README.md

# Enter a shell so the user can execute QtLing, and change the code as they please
CMD ["bash"]
