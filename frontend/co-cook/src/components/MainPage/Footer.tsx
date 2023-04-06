import { Link } from "react-router-dom";
import styled from "styled-components";
import cocookAi from "@/image/cocookAi.png";
import { useInView } from "react-intersection-observer";
import { ReactComponent as LogoWhite } from "@/logo/logoWhite.svg";

function Footer() {
  const { ref, inView, entry } = useInView({
    threshold: 0.8,
    triggerOnce: true,
  });
  return (
    <StyledFooter ref={ref} inView={inView}>
      <div className="ai">
        <img src={cocookAi} alt="" />
      </div>
      <h2>코쿡만의 음성AI 기술</h2>
      <p>AI로 손쉬운 요리를 경험하세요.</p>
      <div className="download">
        <LogoWhite className="nav-logo" />
        <Link to={"/install"} className="nav-link">
          지금 다운로드 받기
        </Link>
      </div>
      <div className="spacer"></div>
    </StyledFooter>
  );
}

export default Footer;

const StyledFooter = styled.header<{ inView: boolean }>`
  @keyframes fadeUp1 {
    0% {
      opacity: 0;
      transform: translateY(50px);
    }
    100% {
      opacity: 1;
      transform: translateY(0px);
    }
  }
  text-align: center;
  & > h2 {
    margin-block: 16px;
    word-break: keep-all;
    margin-top: 80px;
    ${({ theme }) => theme.fontStyles.subtitle2}
    font-size: 2.5rem;
    line-height: 1.2;
    ${({ inView }) =>
      inView ? "animation: contentFade 0.5s ease-out;" : "opacity: 0; transform: translateY(50px);"}
    color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
  }
  & > p {
    word-break: keep-all;
    ${({ theme }) => theme.fontStyles.body1}
    font-size: 1rem;
    margin-bottom: 8px;
    color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
    ${({ inView }) =>
      inView ? "animation: contentFade 0.5s ease-out;" : "opacity: 0; transform: translateY(50px);"}
  }
  .ai {
    height: 300px;
    width: 100%;
    @media (max-width: 734px) {
      height: 50vw;
    }
    display: flex;
    justify-content: center;
    align-items: center;
    & > img {
      width: 600px;
      @media (max-width: 734px) {
        width: 90%;
      }
    }
  }
  .download {
    width: 100vw;
    background-color: ${({ theme }) => theme.Colors.RED_PRIMARY};
    margin-top: 100px;
    padding-top: 24px;
    padding-bottom: 80px;
    height: 200px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }
  .nav-link {
    padding: 12px 18px;
    border: 1px solid ${({ theme }) => theme.Colors.MONOTONE_LIGHT};
    margin-bottom: 24px;
    border-radius: 16px;
    color: ${({ theme }) => theme.Colors.MONOTONE_LIGHT};
    text-decoration: none;
    ${({ theme }) => theme.fontStyles.button}
    cursor: pointer;
    transition: all 0.1s;
    &:hover {
      background-color: ${({ theme }) => theme.Colors.MONOTONE_LIGHT};
      color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
    }
    &:active {
      scale: 0.95;
    }
  }
`;
