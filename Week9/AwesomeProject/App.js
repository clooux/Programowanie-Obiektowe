import { NavigationContainer } from "@react-navigation/native";
import { AppContextProvider } from "./AppContext";
import Tabs from "./components/Tabs";

export default function App() {
  return (
    <AppContextProvider>
      <NavigationContainer>
        <Tabs />
      </NavigationContainer>
    </AppContextProvider>
  );
}
