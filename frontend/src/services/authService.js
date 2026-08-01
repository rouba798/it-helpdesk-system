import axios from "axios";

// Base URL for the ASP.NET Core API — update this to match your backend's launch URL
const API_BASE_URL = "https://localhost:7100/api";

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: { "Content-Type": "application/json" },
});

// Attach the JWT to every request once the user is logged in
api.interceptors.request.use((config) => {
  const token = localStorage.getItem("token");
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export async function login(email, password) {
  const response = await api.post("/auth/login", { email, password });
  return response.data; // { token, fullName, role }
}

export async function register(fullName, email, password, department) {
  const response = await api.post("/auth/register", {
    fullName,
    email,
    password,
    department,
  });
  return response.data;
}

export default api;
