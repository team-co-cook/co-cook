import { jsx as _jsx } from "react/jsx-runtime";
import { ThemeProvider } from "styled-components";
import { createBrowserRouter, RouterProvider } from "react-router-dom";
import theme from "./styles/theme";
import MainPage from "./pages/MainPage";
import "./styles/fonts/pretendard/pretendard.css";
import "./styles/fonts/pretendard/pretendard-subset.css";
import DownloadPage from "./pages/DownloadPage";
function App() {
    return (_jsx(ThemeProvider, { theme: theme, children: _jsx(RouterProvider, { router: router }) }));
}
const router = createBrowserRouter([
    {
        path: "/",
        element: _jsx(MainPage, {}),
    },
    {
        path: "/install",
        element: _jsx(DownloadPage, {}),
    },
]);
export default App;
