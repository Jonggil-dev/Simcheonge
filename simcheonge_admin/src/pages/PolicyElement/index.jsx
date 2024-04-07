import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import Button from "react-bootstrap/Button";
import ButtonGroup from "react-bootstrap/ButtonGroup";
import ButtonToolbar from "react-bootstrap/ButtonToolbar";
import Modal from "react-bootstrap/Modal";
import TopBar from "../Header";
import Form from "react-bootstrap/Form";
import axios from "axios";

function PolicyModify() {
  const [data, setData] = useState([]);
  const { policyId } = useParams();
  const [code, setCode] = useState("");
  const [area, setArea] = useState("");
  const [name, setName] = useState("");
  const [intro, setIntro] = useState("");
  const [supportContent, setSupportContent] = useState("");
  const [supportScale, setSupportScale] = useState("");
  const [etc, setEtc] = useState("");
  const [field, setField] = useState("");
  const [businessPeriod, setBusinessPeriod] = useState("");
  const [periodTypeCode, setPeriodTypeCode] = useState("");
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [ageInfo, setAgeInfo] = useState("");
  const [majorRequirements, setMajorRequirements] = useState("");
  const [residenceIncome, setResidenceIncome] = useState("");
  const [applicationProcedure, setApplicationProcedure] = useState("");
  const [requiredDocuments, setRequiredDocuments] = useState("");
  const [siteAddress, setSiteAddress] = useState("");
  const [mainOrganization, setMainOrganization] = useState("");
  const [mainContact, setMainContact] = useState("");
  const [operationOrganization, setOperationOrganization] = useState("");
  const [operationOrganizationContact, setOperationOrganizationContact] = useState("");
  const [applicationPeriod, setApplicationPeriod] = useState("");
  const [employmentStatus, setEmploymentStatus] = useState("");
  const [specializedField, setSpecializedField] = useState("");
  const [educationRequirements, setEducationRequirements] = useState("");
  const [additionalClues, setAdditionalClues] = useState("");
  const [entryLimit, setEntryLimit] = useState("");
  const [evaluationContent, setEvaluationContent] = useState("");
  const [processed, setProcessed] = useState("");
  const [show, setShow] = useState(false);

  const token = sessionStorage.getItem("token");

  const config = {
    headers: {
      Authorization: `Bearer ${token}`, // 헤더에 accessToken 추가
    },
  };

  const handleClose = () => setShow(false);
  const handleShow = () => setShow(true);
  const API_DOMAIN = process.env.REACT_APP_API_URL;

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await axios.get(API_DOMAIN + "/policy/admin/" + policyId, config);
        if (response.status === 200) {
          setData(response.data.data); // 응답 데이터를 상태에 저장
        } else {
          console.error("Failed to fetch policy data");
        }
      } catch (error) {
        console.error("Error fetching policy data:", error);
      }
    };

    fetchData(); // fetchData 함수 실행
  }, []);

  useEffect(() => {
    console.log("정책데이터:", data);
    setCode(data.code);
    setArea(data.area);
    setName(data.name);
    setIntro(data.intro);
    setSupportContent(data.supportContent);
    setSupportScale(data.supportScale);
    setEtc(data.etc);
    setField(data.field);
    setBusinessPeriod(data.businessPeriod);
    setPeriodTypeCode(data.periodTypeCode);
    setStartDate(data.startDate);
    setEndDate(data.endDate);
    setAgeInfo(data.ageInfo);
    setMajorRequirements(data.majorRequirements);
    setResidenceIncome(data.residenceIncome);
    setApplicationProcedure(data.applicationProcedure);
    setRequiredDocuments(data.requiredDocuments);
    setSiteAddress(data.siteAddress);
    setMainOrganization(data.mainOrganization);
    setMainContact(data.mainContact);
    setOperationOrganization(data.operationOrganization);
    setOperationOrganizationContact(data.operationOrganizationContact);
    setApplicationPeriod(data.applicationPeriod);
    setEmploymentStatus(data.employmentStatus);
    setSpecializedField(data.specializedField);
    setEducationRequirements(data.educationRequirements);
    setAdditionalClues(data.additionalClues);
    setEntryLimit(data.entryLimit);
    setEvaluationContent(data.evaluationContent);
    setProcessed(data.processed);
  }, [data]);

  const handleChange = (e) => {
    const { name, value } = e.target;

    switch (name) {
      case "code":
        setCode(value);
        break;
      case "area":
        setArea(value);
        break;
      case "name":
        setName(value);
        break;
      case "intro":
        setIntro(value);
        break;
      case "supportContent":
        setSupportContent(value);
        break;
      case "supportScale":
        setSupportScale(value);
        break;
      case "etc":
        setEtc(value);
        break;
      case "field":
        setField(value);
        break;
      case "businessPeriod":
        setBusinessPeriod(value);
        break;
      case "periodTypeCode":
        setPeriodTypeCode(value);
        break;
      case "startDate":
        setStartDate(value);
        break;
      case "endDate":
        setEndDate(value);
        break;
      case "ageInfo":
        setAgeInfo(value);
        break;
      case "majorRequirements":
        setMajorRequirements(value);
        break;
      case "residenceIncome":
        setResidenceIncome(value);
        break;
      case "applicationProcedure":
        setApplicationProcedure(value);
        break;
      case "requiredDocuments":
        setRequiredDocuments(value);
        break;
      case "siteAddress":
        setSiteAddress(value);
        break;
      case "mainOrganization":
        setMainOrganization(value);
        break;
      case "mainContact":
        setMainContact(value);
        break;
      case "operationOrganization":
        setOperationOrganization(value);
        break;
      case "operationOrganizationContact":
        setOperationOrganizationContact(value);
        break;
      case "applicationPeriod":
        setApplicationPeriod(value);
        break;
      case "employmentStatus":
        setEmploymentStatus(value);
        break;
      case "specializedField":
        setSpecializedField(value);
        break;
      case "educationRequirements":
        setEducationRequirements(value);
        break;
      case "additionalClues":
        setAdditionalClues(value);
        break;
      case "entryLimit":
        setEntryLimit(value);
        break;
      case "evaluationContent":
        setEvaluationContent(value);
        break;
      case "processed":
        setProcessed(value);
        break;
      default:
        break;
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      const updatedData = {
        code,
        area,
        name,
        intro,
        supportContent,
        supportScale,
        etc,
        field,
        businessPeriod,
        periodTypeCode,
        startDate,
        endDate,
        ageInfo,
        majorRequirements,
        residenceIncome,
        applicationProcedure,
        requiredDocuments,
        siteAddress,
        mainOrganization,
        mainContact,
        operationOrganization,
        operationOrganizationContact,
        applicationPeriod,
        employmentStatus,
        specializedField,
        educationRequirements,
        additionalClues,
        entryLimit,
        evaluationContent,
        processed,
      };

      const response = await axios.patch(`${API_DOMAIN}/policy/${policyId}`, updatedData, config);

      if (response.status === 200) {
        console.log("Policy data updated successfully");
        handleShow();
      } else {
        console.error("Failed to update policy data");
      }
    } catch (error) {
      console.error("Error updating policy data:", error);
    }
  };

  const navigate = useNavigate();
  const handleButtonClick = () => {
    navigate("/");
  };

  return (
    <div>
      <TopBar />
      <h2>PolicyId{policyId}정책</h2>
      <Form>
        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label htmlFor="inputPassword5">code</Form.Label>
          <Form.Control
            type="code"
            name="code"
            placeholder="Enter code"
            value={code}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>area</Form.Label>
          <Form.Control
            type="area"
            name="area"
            placeholder="Enter area"
            value={area}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>name</Form.Label>
          <Form.Control
            type="name"
            name="name"
            placeholder="Enter name"
            value={name}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>intro</Form.Label>
          <Form.Control
            type="intro"
            name="intro"
            placeholder="Enter intro"
            value={intro}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>supportContent</Form.Label>
          <Form.Control
            type="supportContent"
            name="supportContent"
            placeholder="Enter supportContent"
            value={supportContent}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>supportScale</Form.Label>
          <Form.Control
            type="supportScale"
            name="supportScale"
            placeholder="Enter supportScale"
            value={supportScale}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>etc</Form.Label>
          <Form.Control
            type="etc"
            name="etc"
            placeholder="Enter etc"
            value={etc}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>field</Form.Label>
          <Form.Control
            type="field"
            name="field"
            placeholder="Enter field"
            value={field}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>businessPeriod</Form.Label>
          <Form.Control
            type="businessPeriod"
            name="businessPeriod"
            placeholder="Enter businessPeriod"
            value={businessPeriod}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>periodTypeCode</Form.Label>
          <Form.Control
            type="periodTypeCode"
            name="periodTypeCode"
            placeholder="Enter periodTypeCode"
            value={periodTypeCode}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>applicationPeriod</Form.Label>
          <Form.Control
            type="applicationPeriod"
            name="applicationPeriod"
            placeholder="Enter applicationPeriod"
            value={applicationPeriod}
          />
        </Form.Group>

        {/* <Form.Group className="mb-3">
          <Form.Label>applicationPeriod </Form.Label>
          <Form.Control placeholder="Disabled input" disabled value={applicationPeriod} />
        </Form.Group> */}

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>startDate</Form.Label>
          <Form.Control
            type="startDate"
            name="startDate"
            placeholder="Enter startDate"
            value={startDate}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>endDate</Form.Label>
          <Form.Control
            type="endDate"
            name="endDate"
            placeholder="Enter endDate"
            value={endDate}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>ageInfo</Form.Label>
          <Form.Control
            type="ageInfo"
            name="ageInfo"
            placeholder="Enter ageInfo"
            value={ageInfo}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>majorRequirements</Form.Label>
          <Form.Control
            type="majorRequirements"
            name="majorRequirements"
            placeholder="Enter majorRequirements"
            value={majorRequirements}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>employmentStatus</Form.Label>
          <Form.Control
            type="employmentStatus"
            name="employmentStatus"
            placeholder="Enter employmentStatus"
            value={employmentStatus}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>specializedField</Form.Label>
          <Form.Control
            type="specializedField"
            name="specializedField"
            placeholder="Enter specializedField"
            value={specializedField}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>educationRequirements</Form.Label>
          <Form.Control
            type="educationRequirements"
            name="educationRequirements"
            placeholder="Enter educationRequirements"
            value={educationRequirements}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>residenceIncome</Form.Label>
          <Form.Control
            type="residenceIncome"
            name="residenceIncome"
            placeholder="Enter residenceIncome"
            value={residenceIncome}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>additionalClues</Form.Label>
          <Form.Control
            type="additionalClues"
            name="additionalClues"
            placeholder="Enter additionalClues"
            value={additionalClues}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>entryLimit</Form.Label>
          <Form.Control
            type="entryLimit"
            name="entryLimit"
            placeholder="Enter entryLimit"
            value={entryLimit}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>applicationProcedure</Form.Label>
          <Form.Control
            type="applicationProcedure"
            name="applicationProcedure"
            placeholder="Enter applicationProcedure"
            value={applicationProcedure}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>requiredDocuments</Form.Label>
          <Form.Control
            type="requiredDocuments"
            name="requiredDocuments"
            placeholder="Enter requiredDocuments"
            value={requiredDocuments}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>evaluationContent</Form.Label>
          <Form.Control
            type="evaluationContent"
            name="evaluationContent"
            placeholder="Enter evaluationContent"
            value={evaluationContent}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>siteAddress</Form.Label>
          <Form.Control
            type="siteAddress"
            name="siteAddress"
            placeholder="Enter siteAddress"
            value={siteAddress}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>mainOrganization</Form.Label>
          <Form.Control
            type="mainOrganization"
            name="mainOrganization"
            placeholder="Enter mainOrganization"
            value={mainOrganization}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>mainContact</Form.Label>
          <Form.Control
            type="mainContact"
            name="mainContact"
            placeholder="Enter mainContact"
            value={mainContact}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>operationOrganization</Form.Label>
          <Form.Control
            type="operationOrganization"
            name="operationOrganization"
            placeholder="Enter operationOrganization"
            value={operationOrganization}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>operationOrganizationContact</Form.Label>
          <Form.Control
            type="operationOrganizationContact"
            name="operationOrganizationContact"
            placeholder="Enter operationOrganizationContact"
            value={operationOrganizationContact}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        <Form.Group className="mb-3" controlId="formBasicEmail">
          <Form.Label>processed</Form.Label>
          <Form.Control
            type="processed"
            name="processed"
            placeholder="Enter processed"
            value={processed}
            onChange={handleChange}
          />
          <Form.Text className="text-muted">
            We'll never share your email with anyone else.
          </Form.Text>
        </Form.Group>

        {/* 
        <Form.Group className="mb-3" controlId="formBasicCheckbox">
          <Form.Check type="checkbox" label="Check me out" />
        </Form.Group> */}
        <ButtonToolbar aria-label="Toolbar with button groups">
          <ButtonGroup className="me-2" aria-label="First group">
            <Button variant="primary" type="submit" onClick={handleSubmit}>
              Submit
            </Button>
          </ButtonGroup>
          <ButtonGroup className="me-2" aria-label="Second group">
            <Button onClick={handleButtonClick}>List</Button>
          </ButtonGroup>
        </ButtonToolbar>
      </Form>
      <Modal show={show} onHide={handleClose}>
        <Modal.Header closeButton>
          <Modal.Title>Info</Modal.Title>
        </Modal.Header>
        <Modal.Body>정책 수정 완료</Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={handleClose}>
            Close
          </Button>
        </Modal.Footer>
      </Modal>
    </div>
  );
}

export default PolicyModify;
