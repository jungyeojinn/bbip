var pc = null;
var socket = null; // 전역 socket 변수 선언

async function offer() {
    try {
        // WebSocket 연결
        socket = new WebSocket('ws://127.0.0.1:8000/rtc/ws');
        
        socket.onopen = () => {
            console.log("websocket 연결됨");
            const config = {
                sdpSemantics: 'unified-plan',
                iceServers: [
                    {
                        urls: 'stun:stun.l.google.com:19302' // STUN 서버
                    },
                    {
                        urls: 'turn:j11a203.p.ssafy.io', // TURN 서버
                        username: 'username',
                        credential: 'password'
                    }
                ]
            };
            pc = new RTCPeerConnection(config); // 전역 pc 변수 사용

            pc.oniceconnectionstatechange = () => {
                console.log('ICE Connection State:', pc.iceConnectionState);
                if (pc.iceConnectionState === 'connected') {
                    console.log('Connection established!');
                }
            };

            pc.onicecandidate = (event) => {
                if (event.candidate) {
                    console.log("onicecandidate");
                    console.log(event.candidate);
                    socket.send(JSON.stringify({ 
                        type: 'candidate', 
                        candidate: {
                            address: event.candidate.address,
                            candidate: event.candidate.candidate,
                            sdpMid: event.candidate.sdpMid,
                            sdpMLineIndex: event.candidate.sdpMLineIndex,
                            foundation: event.candidate.foundation,
                            component: event.candidate.component,
                            port: event.candidate.port,
                            priority: event.candidate.priority,
                            protocol: event.candidate.protocol,
                            type: event.candidate.type,
                            tcpType: event.candidate.tcpType,
                            usernameFragment: event.candidate.usernameFragment
                        } 
                    }));
                }
            };

            negotiate();
        };

        // WebSocket 메시지 처리
        socket.onmessage = async (event) => {
            const message = JSON.parse(event.data);
            console.log(message);

            try {
                if (event.data instanceof Blob) {
                    const videoElement = document.getElementById('videoElement');
                    videoElement.srcObject = URL.createObjectURL(event.data);
                    videoElement.play();
                } else {
                    if (message.type === 'candidate') {
                        console.log("onmessage:candidate");
                        await pc.addIceCandidate(new RTCIceCandidate(message.candidate));
                    } else if (message.type === 'answer') {
                        console.log("onmessage:answer");
                        await pc.setRemoteDescription(new RTCSessionDescription(message));
                    } else if (message.type === 'offer') {
                        console.log("onmessage:offer");
                        await pc.setRemoteDescription(new RTCSessionDescription(message));
                        const answer = await pc.createAnswer();
                        console.log("onmessage:createanswer");
                        await pc.setLocalDescription(answer);
                        socket.send(JSON.stringify({ type: 'answer', sdp: pc.localDescription.sdp }));
                    }
                }
            } catch (error) {
                console.error('Error handling message:', error);
            }
        };

    } catch (error) {
        console.log(error);
    }
}

function negotiate() {
    console.log("onmessage:negotiate");
    if (!pc) {
        console.error("RTCPeerConnection is not initialized.");
        return;
    }

    pc.addTransceiver('video', { direction: 'sendrecv' });
    pc.addTransceiver('audio', { direction: 'sendrecv' });

    return pc.createOffer()
        .then((offer) => {
            return pc.setLocalDescription(offer);
        })
        .then(() => {
            return fetch('http://70.12.247.123:8000/rtc/offer', {
                body: JSON.stringify({
                    sdp: pc.localDescription.sdp,
                    type: pc.localDescription.type,
                }),
                headers: {
                    'Content-Type': 'application/json'
                },
                method: 'POST'
            });
        })
        .then((response) => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then((answer) => {
            return pc.setRemoteDescription(answer);
        })
        .catch((e) => {
            alert(e);
            console.error('Error in negotiation:', e);
        });
}

async function start() {
    try {
        // 웹캠 및 오디오 스트림 요청
        const stream = await navigator.mediaDevices.getUserMedia({ 
            video: { frameRate: 15 }, 
            audio: true 
        });
        const video = document.getElementById('video');

        // 비디오 요소에 스트림 연결
        video.srcObject = stream;

        // RTCPeerConnection 설정 (pc가 null인 경우에만 초기화)
        if (!pc) {
            console.log("나오면 안됨")
            const config = {
                sdpSemantics: 'unified-plan',
                iceServers: [
                    {
                        urls: 'stun:stun.l.google.com:19302' // STUN 서버
                    },
                    {
                        urls: 'turn:j11a203.p.ssafy.io', // TURN 서버
                        username: 'username',
                        credential: 'password'
                    }
                ]
            };
            pc = new RTCPeerConnection(config);
            
            // ICE 후보 수신 및 전송
            pc.onicecandidate = (event) => {
                if (event.candidate) {
                    console.log("onicecandidate");
                    console.log(event.candidate);
                    socket.send(JSON.stringify({ 
                        type: 'candidate', 
                        candidate: {
                            address: event.candidate.address,
                            candidate: event.candidate.candidate,
                            sdpMid: event.candidate.sdpMid,
                            sdpMLineIndex: event.candidate.sdpMLineIndex,
                            foundation: event.candidate.foundation,
                            component: event.candidate.component,
                            port: event.candidate.port,
                            priority: event.candidate.priority,
                            protocol: event.candidate.protocol,
                            type: event.candidate.type,
                            tcpType: event.candidate.tcpType,
                            usernameFragment: event.candidate.usernameFragment
                        } 
                    }));
                }
            };

            
        }

        // 비디오 및 오디오 트랙을 수신했을 때 처리
        pc.ontrack = (event) => {
            if (event.track.kind === 'video') {
                const video2 = document.getElementById('video2');
                video2.srcObject = event.streams[0];
            } else if (event.track.kind === 'audio') {
                const audio2 = document.getElementById('audio2');
                audio2.srcObject = event.streams[0];
            }
        };

        // 스트림의 모든 트랙을 PeerConnection에 추가
        stream.getTracks().forEach(track => pc.addTrack(track, stream));

        // 오퍼 생성 및 서버에 전송
        const offer = await pc.createOffer();
        await pc.setLocalDescription(offer);
        socket.send(JSON.stringify({ type: 'offer', sdp: pc.localDescription.sdp }));

        document.getElementById('start').style.display = 'none';
        document.getElementById('stop').style.display = 'block';

    } catch (error) {
        console.error('Error accessing media devices.', error);
    }
}

function stop() {
    if (pc) {
        pc.close();
    }
    document.getElementById('start').style.display = 'block';
    document.getElementById('stop').style.display = 'none';
}