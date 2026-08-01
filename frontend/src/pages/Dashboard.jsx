import { useAuth } from "../context/AuthContext";

export default function Dashboard() {
  const { user, logout } = useAuth();

  return (
    <div className="dashboard-placeholder">
      <h1>Welcome, {user?.fullName}</h1>
      <p>Role: {user?.role}</p>
      <p>This is a placeholder — the real dashboard (ticket counts, charts) comes in Week 5.</p>
      <button onClick={logout}>Log out</button>
    </div>
  );
}
