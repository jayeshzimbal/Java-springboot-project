package com.datastore.person.controller;

import com.datastore.person.pojo.Student;
import com.datastore.person.repository.StudentRepository;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class StudentController {

    private static final Logger logger = LoggerFactory.getLogger(StudentController.class);

    @Autowired
    private StudentRepository studentRepository;

    @PostMapping("/student/post")
    public ResponseEntity<String> postStudent(@RequestBody Student student, HttpServletRequest request) {
        studentRepository.save(student);
        logger.info("Posted student to DB : {}", student.getName());
        return ResponseEntity.ok("Student successfully posted.");
    }

    @GetMapping("/student/get/{name}")
    public ResponseEntity<Student> getStudent(@PathVariable String name) {
        logger.info("Getting student by name : {}", name);
        return studentRepository.findByName(name)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/student/all")
    public ResponseEntity<List<Student>> getAllStudents() {
        logger.info("Getting all students");
        return ResponseEntity.ok(studentRepository.findAll());
    }
}