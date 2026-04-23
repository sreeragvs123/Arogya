package com.Grp._8.backend.filters;

import com.Grp._8.backend.entities.User;
import com.Grp._8.backend.repositories.UserRepository;
import com.Grp._8.backend.services.JwtService;
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
import java.util.Optional;

@RequiredArgsConstructor
@Component
public class JwtFilters extends OncePerRequestFilter {

    private final JwtService jwtService;
    private final UserRepository userRepository;

    @Autowired
    @Qualifier("handlerExceptionResolver")
    private HandlerExceptionResolver handlerExceptionResolver;


    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        try {
            final String requestTokenHeader = request.getHeader("Authorization");//get JWt token from header
            if (requestTokenHeader == null || !requestTokenHeader.startsWith("Bearer ")) {//If no token or wrong format → skip authentication, continue to next filter
                filterChain.doFilter(request, response);
                return;
            }

            String jwtToken = requestTokenHeader.split("Bearer ")[1].trim();//Removes "Bearer " prefix to get the actual token
            Long userId = jwtService.getUserIdFromToken(jwtToken);//Decodes and validates JWT, extracts the user ID from claims

            if (userId != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                Optional<User> user = userRepository.findById(userId);
                UsernamePasswordAuthenticationToken authenticationToken =
                        new UsernamePasswordAuthenticationToken(user.get(), null, null);
                authenticationToken.setDetails(
                        new WebAuthenticationDetailsSource().buildDetails(request)
                );
                SecurityContextHolder.getContext().setAuthentication(authenticationToken);

            }
            filterChain.doFilter(request, response);//Pass request to the next filter/controller
        } catch (Exception e) {
            handlerExceptionResolver.resolveException(request, response, null, e);
        }


    }


}
