package com.e102.simcheonge_server;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class SimcheongeServerApplication {
	public static void main(String[] args) {
		SpringApplication.run(SimcheongeServerApplication.class, args);
	}

}
