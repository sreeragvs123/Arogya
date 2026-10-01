package com.Grp._8.backend.security;

import com.Grp._8.backend.entities.enums.Role;
import com.Grp._8.backend.entities.users.UserPrincipal;
import io.jsonwebtoken.Claims;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.servlet.HandlerExceptionResolver;

import java.io.IOException;

@RequiredArgsConstructor
@Component
public class JwtFilters extends OncePerRequestFilter {

    private final JwtService jwtService;

    @Autowired
    @Qualifier("handlerExceptionResolver")
    private HandlerExceptionResolver handlerExceptionResolver;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        try {
            final String requestTokenHeader = request.getHeader("Authorization");
            if (requestTokenHeader == null || !requestTokenHeader.startsWith("Bearer ")) {
                filterChain.doFilter(request, response);
                return;
            }

            String jwtToken = requestTokenHeader.substring(7).trim();
            Claims claims = jwtService.parseClaims(jwtToken); // verifies signature + expiry
            String roleClaim = claims.get("role", String.class);

            // Refresh tokens carry no role claim, so they can't authenticate requests
            if (roleClaim != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                Long userId = Long.valueOf(claims.getSubject());
                Object pid = claims.get("profileId");
                Long profileId = pid instanceof Number n ? n.longValue() : null;

                UserPrincipal principal = new UserPrincipal(
                        claims.get("username", String.class),
                        null,
                        Role.valueOf(roleClaim),
                        userId,
                        profileId
                );

                UsernamePasswordAuthenticationToken authenticationToken =
                        new UsernamePasswordAuthenticationToken(principal, null, principal.getAuthorities());
                authenticationToken.setDetails(
                        new WebAuthenticationDetailsSource().buildDetails(request)
                );
                SecurityContextHolder.getContext().setAuthentication(authenticationToken);
            }

            filterChain.doFilter(request, response);
        } catch (Exception e) {
            handlerExceptionResolver.resolveException(request, response, null, e);
        }
    }
}