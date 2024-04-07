import React, { useEffect, useState } from "react";
import axios from "axios";
import "./index.css";
import TopBar from "../Header";
import PolicyList from "../PolicyList";

function Home() {
  return (
    <div>
      <TopBar />
      <PolicyList />
    </div>
  );
}

export default Home;
