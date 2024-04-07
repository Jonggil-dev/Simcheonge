import Table from "react-bootstrap/Table";
import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import axios from "axios";

function PolicyList() {
  const [data, setData] = useState([]);
  const token = sessionStorage.getItem("token");
  const API_DOMAIN = process.env.REACT_APP_API_URL;
  const config = {
    headers: {
      Authorization: `Bearer ${token}`, // 헤더에 accessToken 추가
    },
  };

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await axios.get(
          API_DOMAIN + "/policy/admin?isProcessed=false",
          config
        );
        if (response.status === 200) {
          const fetchedData = response.data.data ? response.data.data : []; //response가 null일 경우 빈배열로 만들어 아래 map 함수에서 에러 발생 막음
          setData(fetchedData); // 응답 데이터를 상태에 저장
        } else {
          console.error("Failed to fetch policy data");
          setData([]); // 오류 발생 시 빈 배열로 설정하여 안정성 보장
        }
      } catch (error) {
        console.error("Error fetching policy data:", error);
        setData([]); // 예외 처리 시 빈 배열로 설정
      }
    };

    fetchData(); // fetchData 함수 실행
  }, []);

  useEffect(() => {
    console.log("정책데이터:", data);
  }, [data]);

  return (
    <Table striped bordered hover>
      <thead>
        <tr>
          <th>#</th>
          <th>정책 ID</th>
          <th>정책 이름</th>
          <th>가공 여부</th>
        </tr>
      </thead>
      <tbody>
        {data.map((policy, index) => (
          <tr key={policy.policyId}>
            <td>{index + 1}</td>
            <td>{policy.policyId}</td>
            <td>
              <Link
                to={`modify/${policy.policyId}`}
                className="text-dark text-decoration-none"
              >
                {policy.policy_name}
              </Link>
            </td>
            <td>{policy.processed ? "Yes" : "No"}</td>
          </tr>
        ))}
      </tbody>
    </Table>
  );
}

export default PolicyList;
