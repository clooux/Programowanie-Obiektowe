import { NavigationContainer } from "@react-navigation/native";
import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";
import Categories from "./components/Categories";
import Products from "./components/Products";
import Home from "./components/Home";

const Tab = createBottomTabNavigator();

export default function App() {
  return (
    <NavigationContainer>
      <Tab.Navigator>
        <Tab.Screen name="Home" component={Home} />
        <Tab.Screen name="Products" component={Products} />
        <Tab.Screen name="Categories" component={Categories} />
      </Tab.Navigator>
    </NavigationContainer>
  );
}
