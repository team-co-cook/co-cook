import { ThemeProvider } from "styled-components";
import { createBrowserRouter, RouterProvider } from "react-router-dom";

import theme from "./styles/theme";
import MainPage from "./pages/MainPage";
import "./styles/fonts/pretendard/pretendard.css";
import "./styles/fonts/pretendard/pretendard-subset.css";
import DownloadPage from "./pages/DownloadPage";

function App() {
  return (
    <ThemeProvider theme={theme}>
      <RouterProvider router={router} />
    </ThemeProvider>
  );
}

const router = createBrowserRouter([
  {
    path: "/",
    element: <MainPage />,
  },
  {
    path: "/install",
    element: <DownloadPage />,
  },
]);

export default App;
