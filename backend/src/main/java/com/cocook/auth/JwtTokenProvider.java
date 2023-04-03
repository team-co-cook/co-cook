package com.cocook.auth;

import com.cocook.entity.User;
import com.cocook.repository.UserRepository;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Date;
import java.util.List;

@Component
@RequiredArgsConstructor
public class JwtTokenProvider {

    private final PrincipalDetailsService principalDetailsService;
    private final UserRepository userRepository;

    @Value("#{jwt['jwt.secret']}")
    private String secretKey;

    @Value("#{jwt['jwt.validity.in.seconds']}")
    private Integer tokenValid;


    @PostConstruct
    protected void init() {
        secretKey = Base64.getEncoder().encodeToString(secretKey.getBytes(StandardCharsets.UTF_8));
    }

    public String createToken(Long userIdx, List<String> roles) {
        Claims claims = Jwts.claims().setSubject(userIdx.toString());
        claims.put("roles", roles);
        Date now = new Date();

        String token = Jwts.builder()
                .setClaims(claims)
                .setIssuedAt(now)
                .setExpiration(new Date((now.getTime() + tokenValid)))
                .signWith(SignatureAlgorithm.HS256, secretKey)
                .compact();

        return token;
    }

    public Authentication getAuthentication(String token) {
        UserDetails userDetails = principalDetailsService.loadUserByUsername(this.getUserIdx(token).toString());
        return new UsernamePasswordAuthenticationToken(userDetails, "", userDetails.getAuthorities());
    }

    public Long getUserIdx(String token) {
        String userIdx = Jwts.parserBuilder().setSigningKey(secretKey).build().parseClaimsJws(token).getBody().getSubject();
        Long longUserIdx = Long.parseLong(userIdx);
        return longUserIdx;
    }

    public User getUser(String token) {
        Long userIdx = getUserIdx(token);
        return userRepository.findByIdAndIsActiveTrue(userIdx);
    }

    public String resolveToken(HttpServletRequest request) {
        return request.getHeader("AUTH-TOKEN");
    }

    public boolean validateToken(String token) {
        try {
            Jws<Claims> claims = Jwts.parserBuilder().setSigningKey(secretKey).build().parseClaimsJws(token);
            return !claims.getBody().getExpiration().before(new Date());
        } catch (Exception e) {
            return false;
        }
    }

}
