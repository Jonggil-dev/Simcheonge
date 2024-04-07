import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import Button from "react-bootstrap/Button";
import Form from "react-bootstrap/Form";
import axios from "axios";

function Login() {
  const [userLoginId, setUserLoginId] = useState("");
  const [userPassword, setUserPassword] = useState("");
  const navigate = useNavigate();
  const API_DOMAIN = process.REACT_APP_API_URL;

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      const response = await fetch(API_DOMAIN + "/auth/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ userLoginId, userPassword }),
      });

      //   let data1 = await response.text();
      const data = await response.json();
      console.log("data: " + data.data.accessToken);
      if (data.data.accessToken) {
        // 토큰을 상태에 저장하거나 쿠키/로컬 스토리지에 저장합니다.
        sessionStorage.setItem("token", data.data.accessToken);
        sessionStorage.setItem("loginId", data.data.userLoginId);
        navigate("/");
      } else {
        console.error("Login failed");
      }
    } catch (error) {
      console.error("Error logging in:", error);
    }
  };

  useEffect(() => {
    // Fetch data here
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;
    switch (name) {
      case "userLoginId":
        setUserLoginId(value);
        break;
      case "userPassword":
        setUserPassword(value);
        break;
      default:
        break;
    }
  };

  return (
    <div>
      <Form>
        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>Id</Form.Label>
          <Form.Control
            type="userLoginId"
            name="userLoginId"
            value={userLoginId}
            placeholder="Enter userLoginId"
            onChange={handleChange}
          />
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicPassword">
          <Form.Label>Password</Form.Label>
          <Form.Control
            type="userPassword"
            name="userPassword"
            value={userPassword}
            placeholder="Password"
            onChange={handleChange}
          />
        </Form.Group>

        <Button variant="primary" type="submit" onClick={handleSubmit}>
          Submit
        </Button>
      </Form>
    </div>
  );
}

export default Login;
