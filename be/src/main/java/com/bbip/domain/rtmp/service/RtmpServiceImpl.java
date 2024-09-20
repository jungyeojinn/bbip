package com.bbip.domain.rtmp.service;

import com.bbip.domain.rtmp.Dto.StreamKeyDto;
import com.bbip.domain.rtmp.Dto.StreamListDto;
import com.bbip.domain.rtmp.entity.RtmpResult;
import com.bbip.domain.rtmp.entity.RtmpServerEntity;
import com.bbip.domain.rtmp.entity.StreamKeyEntity;
import com.bbip.domain.rtmp.entity.StreamKeyIdEntity;
import com.bbip.domain.rtmp.repository.RtmpServerRepository;
import com.bbip.domain.rtmp.repository.StreamKeyRepository;
import com.bbip.domain.user.entity.UserEntity;
import com.bbip.domain.user.repository.UserRepository;
import com.bbip.global.util.JwtUtil;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Optional;

@Service
@Slf4j
@RequiredArgsConstructor
public class RtmpServiceImpl implements RtmpService {

    private static final String PREFIX = "[f=flv]";
    private final StreamKeyRepository streamKeyRepository;
    private final UserRepository userRepository;
    private final RtmpServerRepository serverRepository;
    private final JwtUtil jwtUtil;

    @Override
    public String getRtmpUrls(String accessToken) {

        // JWT토큰에서 사용자 id 추출
        int userId = jwtUtil.getUserIdFromJWT(accessToken);
        List<RtmpResult> rtmpResults = streamKeyRepository.findStreamRtmpUrl(userId);

        StringBuilder result = new StringBuilder();
        for (Iterator<RtmpResult> i = rtmpResults.iterator(); i.hasNext();) {
            RtmpResult rtmp = i.next();
            result.append(PREFIX)
                    .append(rtmp.getServerUri().toString())
                    .append(rtmp.getKey().toString());
            if (i.hasNext()) result.append("|");
        }

        log.info("송출 대상 url 목록 조회 : {}", result.toString());
        return result.toString();
    }

    @Override
    @Transactional
    public StreamKeyDto updateStreamkey(String accessToken, StreamKeyDto streamKeyDto) {

        // JWT토큰에서 사용자 id 추출
        int userId = jwtUtil.getUserIdFromJWT(accessToken);

        UserEntity userEntity = userRepository.findById(userId);
        Optional<RtmpServerEntity> rtmpServerEntity = serverRepository.findById(streamKeyDto.getServerId());
        StreamKeyIdEntity streamKeyId = StreamKeyIdEntity.builder()
                                            .userId(userId)
                                            .serverId(streamKeyDto.getServerId()).build();

        if (streamKeyDto.getStreamKey().isBlank() || streamKeyDto.getStreamKey().isEmpty()) {
            streamKeyRepository.deleteStreamKey(userId, streamKeyDto.getServerId());
            log.info("스트림키 삭제");
        } else {
            streamKeyRepository.save(
                    StreamKeyEntity.builder()
                            .id(streamKeyId)
                            .userEntity(userEntity)
                            .serverEntity(rtmpServerEntity.orElseThrow())
                            .key(streamKeyDto.getStreamKey())
                            .stream(false).build()
            );
            log.info("스트림키 업데이트 완료");
        }

        return streamKeyDto;
    }

    @Override
    public List<StreamKeyDto> getServers(String accessToken) {

        // JWT토큰에서 사용자 id 추출
        int userId = jwtUtil.getUserIdFromJWT(accessToken);

        List<RtmpResult> rtmpResults = streamKeyRepository.findAllRtmpUrl(userId);
        List<StreamKeyDto> DtoResult = new ArrayList<>();
        for (RtmpResult rtmpResult : rtmpResults) {
            DtoResult.add(StreamKeyDto.builder()
                    .serverId(rtmpResult.getServerId())
                    .streamKey(rtmpResult.getKey()).build());
        }
        return DtoResult;
    }

    @Override
    @Transactional
    public List<StreamKeyDto> updateStreamList(String accessToken, StreamListDto streamList) {

        // JWT토큰에서 사용자 id 추출
        int userId = jwtUtil.getUserIdFromJWT(accessToken);

        List<RtmpResult> rtmpResults = streamKeyRepository.findAllRtmpUrl(userId);
        List<StreamKeyDto> DtoResult = new ArrayList<>();
        for (RtmpResult rtmpResult : rtmpResults) {
            if (streamList.getServers().contains(rtmpResult.getServerId())) {
                streamKeyRepository.updateStreamKey(userId, rtmpResult.getServerId(), true);
                DtoResult.add(new StreamKeyDto(rtmpResult.getServerId(), rtmpResult.getKey()));
            } else {
                streamKeyRepository.updateStreamKey(userId, rtmpResult.getServerId(), false);
            }
        }
        return DtoResult;
    }
}
