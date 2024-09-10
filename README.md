# TIL - 2024-08-27

## 식물 재테크 관련 질문 정리
1. **식물 재테크의 우선순위**
   - 식물을 키우고 관리하는 것이 우선인지, 재테크가 목적인지에 대한 고민.
  
2. **병충해 관리 여부**
   - 병충해를 실제로 관리하는지?
   - 병충해 진단 AI 기능이 있는 어플리케이션 사용 가능성에 대한 질문.

3. **식물 구매 시 고려 사항**
   - 식물을 구매할 때 어떤 점을 주로 고려하는지?
   - 판매자에게 어떤 정보를 얻어야 하는지?

4. **식물 구매 및 사진 관리**
   - 구매 시 현재 사진을 받는지?
   - 식물 판매 시 사진 업데이트 주기에 대한 질문.

5. **식물 재테크 중 불편한 점**
   - 관리 및 판매 시 가장 불편하게 느꼈던 요소에 대한 질문.

6. **식물 목록화 및 관리 의향**
   - 내가 키우는 식물을 목록화해서 관리할 의향이 있는지?
   - 물주기 알림 및 상태 변화 기록의 필요성에 대한 질문.

7. **가격 산정 기준**
   - 가격을 산정할 때 시세, 경매 시세 등 어떤 기준을 사용하는지에 대한 질문.

8. **식물 선택 기준**
   - 식물을 선택하는 기준에 대한 질문.

9. **식물 관리 정보 출처**
   - 식물 관리 방법에 대한 정보를 어디서 얻는지에 대한 질문.

10. **식물 관리 시간**
    - 하루에 식물 관리에 얼마 정도의 시간을 할애하는지에 대한 질문.

---

# TIL - 2024-08-28

## 랜딩 페이지 구성
1. **카카오 소셜 로그인**
   - 사용자가 쉽게 로그인할 수 있도록 카카오 소셜 로그인 기능 포함.

## 메인 페이지 구성
1. **구체적인 항목 필요**
   - 메인 페이지에 포함될 구체적인 항목들에 대한 추가 아이디어 필요.

---

# TIL - 2024-08-29

## 식물 관리 및 판매 플랫폼 기능 정리
1. **식물 등록**
   - 종류, 메모, 사진, 등록일(완료 시 자동), 마지막 물 준 날 기록.
   - 식물의 크기(판매 등록 시 필수 입력, 추가 정보, 타입 선택).
   - 상태 진단(판매 등록 시 필수 입력, 추가 정보).
   - 추가정보란: 등록 시 필수 입력이 아니며, 상세 페이지에서 언제든 추가/수정 가능.

2. **판매 등록**
   - 버튼 하나로 판매 등록 가능.
   - 자동으로 등록한 식물 정보가 마켓으로 넘어가게.
   - 판매 등록 이후에도 관리 가능하며, 마켓 쪽에서는 자동으로 업데이트.
   - 판매 정보: 등록되어 있는 식물 정보(종류, 사진, 등록일, 상태) + 가격, 판매 등록일.

3. **거래**
   - 채팅, 결제 기능.
   - 구매자가 식물을 받은 후 사진을 찍어 판매자가 올린 사진과 유사도 분석을 통해 신뢰도 평가.

4. **마켓**
   - 시세: 크롤링을 통해 평균값, 범위(최저~최고) 제공.
   - 시세 추세 제공.
   - 상품(식물) 정보 제공.

# TIL - 2024-09-02

## 새로운 주제 선정에 관한 고찰 
1. **프로젝트 기능 논의**
   - 촬영했던 사진 블러처리 후 저장
   - 촬영했던 영상 블러처리 후 저장
   - 실시간 영상 블러처리 후 live Streaming

2. **문서 작업**
   1. 와이어 프레임 작성
   2. API 규격연동서 작성
   3. 시퀀스 다이어그램 작성
   4. 간트 차트 작성
   5. 요구사항 명세서 작성

3. **개인별 담당 파트 분배**
   - 상무, 호진: 와이어 프레임 작성
   - 여진, 예림: AI 팀 모델 탐색 및 모델 분석
   - 장우, 예진: BE 팀 프로젝트 레거시 코드 작성 및 BE 파트 분배

# TIL - 2024-09-03
1. **RTMP 프로토콜이란?**
   - 실시간 영상을 효율적으로 전송 및 전달하는 프로토콜로 일반적으로 알고있는 AfreecaTV, YoutubeLive, Twitch에서 Streming 서버에서도 실제로 사용하고 있는 프로토콜.
2. **프로젝트 아키텍쳐 접근**
   - 논의 1. 실시간 영상을 어떻게 AI 모델에 적용하는가?
      일단 기본적으로 OBS 스튜디오는 영상 서버가 존재하지 않는다. 영상을 그대로 스트리밍 서버에 적용하면 되기때문에 영상 서버가 존재하지 않음. 하지만 우리의 서비스는 그대로 영상을 적용하는 것이 아닌, AI 모델에 적용된 영상을 인코딩해서 스트리밍 서비스에 보내야하기때문에 별도 서버가 존재함. 
      별도의 서버를 둔다면 아무래도 Latency가 생길 것이기 때문에 속도, 성능 개선에 초점을 두어야한다.
   - 논의 2. AI 모델 서빙은 어떻게 하는 것이 가장 효율적인가?
      기본적으로 잘 알려진 모델 서빙은 fastAPI를 통해서 모델을 서빙한다. 하지만 fastAPI 보다 Nvidea에서 최적화를 위한 별도의 http 통신을 위한 웹서버를 개발하였음. Triton.
      하지만 fastAPI로 서빙하였을 때 문제가 발생하지 않는다면 별도로 triton을 사용하지 않는다고 생각함. 하지만 fastAPI로의 서빙은 분명 latency에 대해서 비효율을 부를 것이기 때문에 1. fastAPI로의 서빙, 2. triton으로 변경에 대한 과정을 거쳐야할 것.
3. **AI 모델 서빙과 인코딩의 순서?**
   -  우리의 백엔드 메인 서버(Spring BOOT)는 API 게이트 웨이, AI 모델 서버로의 중간 프록시, 인코딩의 역할을 담당한다. 클라이언트가 촬영하고 있는 영상의 데이터를 AI 모델을 통해서 블러처리, 인코딩 처리 후 스트리밍 서버로 송출하면 되는 과정. 
   하지만 클라이언트가 촬영하고있는 영상을 Spring boot -> AI 모델 -> Spring boot -> 클라이언트로 재송출이 이루어져야 하기때문에 인코딩을 중간 단계에 넣는다면 High Latency를 피할 수가 없을 것. 인코딩하는 과정, 인코딩이 완료된 영상을 RTMP 프로토콜로 전송하는 과정은 후순위로 처리. 현재는 AI 모델 서빙을 fastAPI로 서빙할지, triton으로 서빙할지도 선순위로 고려해야한다. 

# 어렵다.

# TIL - 2024-09-04
1. **현업 멘토링 관련 질문**
   - 백엔드 파트에서 이 프로젝트를 접근할 때 고려하고 기술적으로 생각해보아야하는 상황이 어떤 것이 있을까요?
API 개발은 많아보이지 않아서, ML 모델 배포방식(롤링, 블루그린, 카나리 배포) 쪽에서 강점을 주는 것을 생각 중인데 추천하시나요?
모델 업데이트가 자주 있는 일이 아니면 모델 배포에 신경을 많이 쓰지는 않고, 일반적인 서버 배포 방식으로 한다.
그럼에도 롤링, 블루그린, 카나리 배포와 같은 배포 방식이 필요하긴 하니 사용하는 것은 괜찮은 것 같다. 그렇지만 여기에 에너지를 많이 쏟을 것 같지는 않다.
일반적인 영상 스트리밍 서비스를 배포할 때 유의해야 할 부분들을 고려하면 좋을 것 같다. ‘끊기면 안된다는 요구사항을 만족하기 위해서 어떠한 방식으로 라우팅 할 것인가’를 고민해보면 백엔드 파트에서 가져갈 만한 포인트가 될 수 있을 것 같다.
   - DevOps와 백엔드의 구분이 어떻게 되어 있나요?
devops의 업무 영역 정의는 회사마다 다르다. 카카오의 devops 팀은 백엔드 엔지니어가 직접 할 수 있도록 플랫폼을 만드는 조직이다. 각 배포 서비스?를 카카오 인프라 버전으로 만드는 클라우드 플랫폼 조직이라고 생각하면 된다.
카카오페이는 금융권이다보니, 법적으로 배포 담당자를 지정해야 해서 개발 담당자와 배포 담당자가 분리되어 있다. 카카오페이의 devops는 devops 작업을 할 것이고, 보통 카카오는 코드를 작성한 개발자가 배포하는 방식이다.
   - 신입 입장에서 MSA 아키텍처에 접근할 때, 볼륨이 크지 않다보니 쿠버네티스나 MSA를 도입하기 꺼려지는 부분이 있는데, 어떻게 생각하시나요?
필요 없으면 안써도 된다. 오면 쓴다. 알고 있으면 좋지만, 모른다고 큰 문제 없다.
하지만 컨테이너 기반 개발은 알고 있어야 한다. 프로젝트를 도커 이미지나 컨테이너 이미지로 만드는..?? secret .. 뭐 볼트같은 시크릿 매니저…?로 유출되지 않도록 한다던가 하는 부분들을 알고 있으면 도움이 된다.
AI 관련된 백엔드 직무를 희망한다면, 백엔드 서빙 구현체와 모델이 분리되어 있는 경우가 많아 모델을 다른 데서 받아와서 서빙해야 하는데, 이런 부분을 어떻게 매끄럽게 할 것인가에 대해서 고민해보면 좋다. 또 현실적으로 컨테이너가 떠있는 채로 모델 업데이트를 할 수 있어야 한다던가 하는 부분에 대한 고민도 계속 해봐야 한다

# TIL - 2024-09-06
1. **영상 처리 및 전송 방식에 대한 학습 내용 요약**
   - 영상 자체 전송: 클라이언트에서 압축된 영상 스트림을 서버로 바로 전송. 네트워크 대역폭 절약 및 실시간 스트리밍에 유리.
   프레임 단위 슬라이스 전송: 영상을 프레임별로 잘라 이미지 형태로 전송. AI 모델에서 각 프레임을 독립적으로 처리할 수 있음.
   WebSocket vs gRPC 비교

   - WebSocket: 브라우저 친화적이며, 양방향 실시간 통신에 적합. 브라우저와 클라이언트 간의 실시간 데이터 교환이 필요할 때 유리하지만, 패킷 손실에 대한 에러 처리와 신뢰성 측면에서는   한계가 있음.
   gRPC: HTTP/2 기반으로 높은 성능과 효율적인 데이터 전송 제공. ProtoBuf를 통해 데이터를 압축해 전송하고, 강력한 에러 핸들링과 신뢰성 있는 스트리밍 지원. 브라우저에서 사용하려면 추가 작업 필요.
   효율적 사용 시나리오

   - WebSocket은 브라우저 기반 애플리케이션에서 실시간 상호작용과 빠른 개발이 중요할 때 적합.
gRPC는 영상 프레임과 같은 대용량 데이터를 더 효율적이고 신뢰성 있게 전송해야 할 때 유리하며, 네트워크 성능이 중요할 경우 강력한 솔루션이 될 수 있음.

# TIL - 2024-09-09
1. **Spring Security 도입**
2. **JWT 토큰 관리 도입**
3. **Redis 도입 고려**
4. **Oauth 2.0 도입**

# TIL - 2024-09-10

1. **아키텍쳐 관련 고민**
   - 우리의 서비스는 크게 3가지 서버로 이루어진다. 프론트(flutter), 백엔드(Spring boot), AI모델 서버(fastAPI) 우리의 프로젝트가 '실시간'이다보니 제일 빠른, 제일 적은 latency를 User에게 제공해야하는데 어떤 아키텍쳐를 어떤 프로토콜로 거쳐야하는지 고민이 된다. 하나하나 latency를 측정해봐야하지않을까?

