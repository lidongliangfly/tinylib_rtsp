
# makfile for a tiny net/rtsp library written by huangsanyi

CC = gcc
LD = gcc
AR = ar -r

TINYLIB_ROOT = /e/tinylib

CPP_FLAGS = -I. -I$(TINYLIB_ROOT)
C_FLAGS = -Wall -Werror -fno-omit-frame-pointer -march=native -g
LD_FLAGS = -L./output -ltinylib.rtsp -L$(TINYLIB_ROOT)/output -ltinylib -lws2_32 -lpthread

TINYLIB_RTSP = output/libtinylib.rtsp.a

RTSP_OBJS = \
	tinylib/rtsp/rtsp_message_codec.o \
	tinylib/rtsp/rtsp_request.o \
	tinylib/rtsp/rtsp_server.o \
	tinylib/rtsp/rtsp_session.o \
	tinylib/rtsp/sdp.o

RTP_OBJS = \
	tinylib/rtp/rtp_peer.o

# unit test

## msg codec
TEST_MSG_CODEC_BIN = output/test_rtsp_msg_codec
TEST_MSG_CODEC_OBJS = test/test_rtsp_msg_codec.o

## rtsp
TEST_RTSP_SERVER_BIN = output/test_rtsp_server
TEST_RTSP_SERVER_OBJS = test/test_rtsp_server.o
TEST_RTSP_REQUEST_BIN = output/test_rtsp_request
TEST_RTSP_REQUEST_OBJS = test/test_rtsp_request.o

## SDP
TEST_SDP_BIN = output/test_sdp_parser
TEST_SDP_OBJS = test/test_sdp_parser.o

.PHONY: all clean test

all: $(TINYLIB_RTSP)

$(TINYLIB_RTSP): $(RTP_OBJS) $(RTSP_OBJS)
	$(AR) $(TINYLIB_RTSP) $^

test: $(TINYLIB_RTSP) \
	      $(TEST_MSG_CODEC_OBJS) \
	      $(TEST_RTSP_REQUEST_OBJS)  \
	      $(TEST_RTSP_SERVER_OBJS) \
	      $(TEST_SDP_OBJS)
	$(LD) $(TEST_MSG_CODEC_OBJS) -o $(TEST_MSG_CODEC_BIN) $(LD_FLAGS)
	$(LD) $(TEST_RTSP_REQUEST_OBJS) -o $(TEST_RTSP_REQUEST_BIN) $(LD_FLAGS)
	$(LD) $(TEST_RTSP_SERVER_OBJS) -o $(TEST_RTSP_SERVER_BIN) $(LD_FLAGS)
	$(LD) $(TEST_SDP_OBJS) -o $(TEST_SDP_BIN) $(LD_FLAGS)

%.o: %.c
	$(CC) -c $^ -o $@ $(CPP_FLAGS) $(C_FLAGS)

clean:
	rm -f $(TINYLIB_RTSP)
	rm -f $(RTP_OBJS) $(RTSP_OBJS)
	rm -f $(TEST_MSG_CODEC_OBJS) $(TEST_MSG_CODEC_BIN)
	rm -f $(TEST_RTSP_REQUEST_OBJS) $(TEST_RTSP_REQUEST_BIN)
	rm -f $(TEST_RTSP_SERVER_OBJS) $(TEST_RTSP_SERVER_BIN)
	rm -f $(TEST_SDP_OBJS) $(TEST_SDP_BIN)
