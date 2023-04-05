import { jsx as _jsx, jsxs as _jsxs } from "react/jsx-runtime";
import styled from "styled-components";
import NavBar from "../components/common/NavBar";
import Header from "../components/MainPage/Header";
import PhotoSearch from "../components/MainPage/PhotoSearch";
import VoiceRecipe from "../components/MainPage/VoiceRecipe";
import VoiceSearch from "../components/MainPage/VoiceSearch";
import Footer from "../components/MainPage/Footer";
function MainPage() {
    return (_jsxs(StyledMainPage, { children: [_jsx(NavBar, {}), _jsx(Header, {}), _jsx(VoiceRecipe, {}), _jsx(VoiceSearch, {}), _jsx(PhotoSearch, {}), _jsx(Footer, {})] }));
}
export default MainPage;
const StyledMainPage = styled.div `
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-inline: 24px;
  overflow-x: hidden;
  width: 100vw;
  box-sizing: border-box;
`;
