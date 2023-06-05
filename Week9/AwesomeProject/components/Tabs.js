import React, { useContext } from "react";
import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";
import Categories from "./Categories";
import Products from "./Products";
import Home from "./Home";
import Cart from "./Cart";
import { Feather } from "@expo/vector-icons";
import { AppContext } from "../AppContext";

const Tab = createBottomTabNavigator();

export default function Tabs() {
  const { getCart } = useContext(AppContext);
  return (
    <Tab.Navigator>
      <Tab.Screen name="Home" component={Home} />
      <Tab.Screen name="Products" component={Products} />
      <Tab.Screen name="Categories" component={Categories} />
      <Tab.Screen
        name="Cart"
        component={Cart}
        options={{
          tabBarLabel: "Cart",
          tabBarIcon: () => (
            <Feather name="shopping-cart" size={24} color="black" />
          ),
          tabBarBadge: getCart(),
        }}
      />
    </Tab.Navigator>
  );
}
