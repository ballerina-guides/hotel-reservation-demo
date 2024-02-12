import Cookies from "js-cookie";
import { useEffect, useState } from "react";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import RoomListing from "./pages/room_listing";
import Header from "./layout/AppBar";
import ReservationAddingPage from "./pages/reservations_adding";
import ReservationListing from "./pages/reservation_listing";
import { UserContext } from "./contexts/user";
import { User } from "./types/generated";
import ReservationUpdatingPage from "./pages/reservations_updating";
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { ThemeProvider } from "@mui/material/styles";
import NotFound from "./pages/not_found";
import LandingPage from "./pages/landing_page";
import theme from "./theme";

const FakeLoginPage = () => {
  return (
    <div>
      <button
        onClick={() => {
          Cookies.set(
            "userinfo",
            "eyJhdF9oYXNoIjoiYjJfSmlkcHFuR05ocDZWdUN0ZGM3ZyIsInN1YiI6ImRlbW8iLCJhbXIiOlsiY2hvcmVvX2luX2J1aWx0X2lkcF9hdXRoZW50aWNhdG9yIl0sImlzcyI6Imh0dHBzOi8vc3RzLmNob3Jlby5kZXY6NDQzL29hdXRoMi90b2tlbiIsImxhc3RfbmFtZSI6IkRvZSIsImdyb3VwcyI6ImNob3JlbyIsImF1ZCI6InhFU3NDQmZLMFRNWFpMZVhMdjZWbXdaOWdvRWEiLCJjX2hhc2giOiI3WVhlOW9UcTVTUlNwV2FGeWZPaUNBIiwibmJmIjoxNzA3MDI5ODUyLCJhenAiOiJ4RVNzQ0JmSzBUTVhaTGVYTHY2Vm13Wjlnb0VhIiwiZXhwIjoxNzA3MDMzNDUyLCJpYXQiOjE3MDcwMjk4NTIsImZpcnN0X25hbWUiOiJKb2huIiwiZW1haWwiOiJqb2huQGV4YW1wbGUub3JnIiwidXNlcm5hbWUiOiJkZW1vIn0="
          );
          window.location.pathname = "/rooms";
        }}
      >
        login-quickly
      </button>
    </div>
  );
};

export default function App() {
  const [signedIn, setSignedIn] = useState(false);
  const [user, setUser] = useState<User>({
    email: "",
    id: "",
    name: "",
    mobileNumber: "",
  });
  const [isAuthLoading, setIsAuthLoading] = useState(true);

  function getMappedUser(userInfo: any): User {
    return {
      email: userInfo?.email || "",
      id: userInfo?.sub || "",
      name: userInfo?.first_name + " " + userInfo?.last_name,
      mobileNumber: userInfo?.mobile_number || "",
    };
  }

  useEffect(() => {
    setIsAuthLoading(true);
    if (Cookies.get("userinfo")) {
      // We are here after a login
      const userInfoCookie = Cookies.get("userinfo");
      sessionStorage.setItem("userInfo", userInfoCookie || "");
      Cookies.remove("userinfo");
      var userInfo = userInfoCookie ? JSON.parse(atob(userInfoCookie)) : {};
      setSignedIn(true);
      setUser(getMappedUser(userInfo));
    } else if (sessionStorage.getItem("userInfo")) {
      // We have already logged in
      var userInfo = JSON.parse(atob(sessionStorage.getItem("userInfo")!));
      setSignedIn(true);
      setUser(getMappedUser(userInfo));
    } else {
      console.log("User is not signed in");
      if (
        window.location.pathname !== "/auth/login" &&
        window.location.pathname !== "/"
      ) {
        window.location.pathname = "/auth/login";
      }
    }
    setIsAuthLoading(false);
  }, []);

  if (isAuthLoading) {
    return <div>User authenticating...</div>;
  }

  return (
    <>
      <ThemeProvider theme={theme}>
        <UserContext.Provider value={user}>
          <Header />
          <ToastContainer />
          <div
            style={{
              display: "flex",
              flexDirection: "column",
              alignItems: "center",
              flexGrow: 1,
            }}
          >
            <BrowserRouter>
              <Routes>
                {/* rooms */}
                <Route path="/" Component={LandingPage} />
                <Route path="/rooms" Component={RoomListing} />
                {/* reservations */}
                <Route path="/reservations" Component={ReservationListing} />
                {/* new reservation */}
                <Route
                  path="/reservations/new"
                  Component={ReservationAddingPage}
                />
                {/* update reservation */}
                <Route
                  path="/reservations/change"
                  Component={ReservationUpdatingPage}
                />
                {/* Fake login page. This will only be applied for the local deployment*/}
                <Route path="/auth/login" Component={FakeLoginPage} />
                {/* Otherwise, show not found page */}
                <Route path="*" Component={NotFound} />
              </Routes>
            </BrowserRouter>
          </div>
        </UserContext.Provider>
      </ThemeProvider>
    </>
  );
}
