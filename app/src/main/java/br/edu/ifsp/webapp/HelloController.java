package br.edu.ifsp.webapp;

import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class HelloController {

    @Value("${app.version:dev}")
    private String version;

    @GetMapping("/hello")
    public Map<String, String> hello() {
        return Map.of("message", "Olá do IFSP Araraquara", "version", version);
    }
}
