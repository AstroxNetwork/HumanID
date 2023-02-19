import { BrowserRouter } from 'react-router-dom';
import { Routes, Route } from "react-router-dom"
// import App from '../App';
import Layout from '../layout';
import AssetsPage from '../page/Assets';
import HumanID from '../page/HumanID';

export const Router = () => {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Layout />}>
          <Route index element={<HumanID />}></Route>
          {/* <Route index element={<App />}></Route> */}
          <Route path="/assets" element={<AssetsPage />}></Route>
        </Route>
      </Routes>
    </BrowserRouter>
  )
}